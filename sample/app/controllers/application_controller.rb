class ApplicationController < ActionController::Base
  if defined? PlayAuth
    include PlayAuth::SessionsHelper
    helper PlayAuth::SessionsHelper
  end
end
