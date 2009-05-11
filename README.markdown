FirePHP Rails Plugin
====================

This plugin allows you to log messages and objects from your Rails controllers and views to the [FirePHP][1] console.

You can use `firephp`, or its alias `fb`

The first parameter is the message to be sent. This can be any Ruby object that responds to the `to_json` method.

The second optional parameter is the log level as a symbol. This can be one of `:log`, `:info`, `:warn`, or `:error`. It defaults to `:log`.

Messages will not be logged in the production environment.

Installation
============

Install the plugin:

    script/plugin install http://github.com/smith/firephp_rails/tree/master

Add to your application controller:

    class ApplicationController < ActionController::Base
      ...
      include FirePHP
      ...
    end

Example
=======

In a controller:

    class ThingsController < ApplicationController
      ...
      def index
        ...
        firephp(params)
        fb("OK!", :info)
        ...
      end
      ...
    end

In a view:

    <% fb("Uh-oh!", :warn) %>

Copyright (c) 2009 Nathan L Smith, released under the MIT license


  [1]: http://www.firephp.org
