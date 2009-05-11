module FirePHP
  def self.included(controller)
    controller.after_filter :firephp_filter
  end

  protected
    def firephp(obj = "", type = :log)
      @firephp ||= []
      types = [:log, :info, :warn, :error] 
      type = (types.include?(type) ? type : :log).to_s.upcase
      @firephp << [type, obj]
    end
    alias_method :fb, :firephp

  private
    def firephp_filter
      # Add headers only when browser has FirePHP-Plugin
      return if !(request.headers["HTTP_USER_AGENT"]=~/FirePHP\//)
      # Do not add headers in production mode
      return if ENV["RAILS_ENV"] == "production"
      return if @firephp.blank?
      
      headers["X-FirePHP-Data-100000000001"]='{'
      headers["X-FirePHP-Data-200000000001"]='"FirePHP.Dump":{'
      headers["X-FirePHP-Data-200000000002"]="\"RailsVersion\":\"#{RAILS_GEM_VERSION}\","
      headers["X-FirePHP-Data-299999999999"]='"__SKIP__":"__SKIP__"},'
      headers["X-FirePHP-Data-300000000001"]='"FirePHP.Firebug.Console":['
      count=2
      @firephp.each do |arr|
        type = arr.shift
        next if !(type=~/^(LOG|INFO|WARN|ERROR)$/)
        arr.each do |a|
          headers["X-FirePHP-Data-3#{sprintf("%011d", count)}"]="[\"#{type}\",#{a.to_json}],"
          count+=1
        end
      end
      headers["X-FirePHP-Data-399999999999"]='["__SKIP__"]],'
      headers["X-FirePHP-Data-999999999999"]='"__SKIP__":"__SKIP__"}'
    end
end
