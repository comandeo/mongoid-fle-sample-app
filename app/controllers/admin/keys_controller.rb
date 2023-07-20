module Admin
  class KeysController < ApplicationController
    def index
      @users = User.all
    end
  end
end
