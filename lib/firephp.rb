module FirePHP
  def self.included(controller)
    controller.after_filter :firephp_filter
    controller.helper_method :firephp, :fb
  end

  protected
    def firephp(obj = "", type = :log)
      @firephp ||= []
      types = [:log, :info, :warn, :error] 
      type = (types.include?(type) ? type : :log).to_s.upcase
      @firephp << { :type => type, :object => obj }
    end
    alias_method :fb, :firephp

  private
    def firephp_filter
      @firephp ||= []
      # Add headers only when browser has FirePHP-Plugin
      return if !(request.headers["HTTP_USER_AGENT"]=~/FirePHP\//)
      # Do not add headers in production mode
      return if ENV["RAILS_ENV"] == "production"
      return if @firephp.empty?

      headers["X-Wf-Protocol-1"] = "http://meta.wildfirehq.org/Protocol/JsonStream/0.2"
      headers["X-Wf-1-Plugin-1"] = "http://meta.firephp.org/Wildfire/Plugin/FirePHP/Library-FirePHPCore/0.3"
      headers["X-Wf-1-Structure-1"] = "http://meta.firephp.org/Wildfire/Structure/FirePHP/FirebugConsole/0.1"

      count = 1
      @firephp.each do |o|
        next if !(o[:type] =~ /^(LOG|INFO|WARN|ERROR)$/)
        msg = "[#{{ "Type" => o[:type] }.to_json},#{o[:object].to_json}]"
        headers["X-Wf-1-1-1-#{count}"] = "#{msg.length}|#{msg}|"
        count+=1
      end
    end
end
