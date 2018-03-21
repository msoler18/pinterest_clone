class Api::V1::PinsController < ApplicationController
  before_action :restrict_access
  respond_to :json  

  def index
    render json: Pin.all.order('created_at DESC')
  end

  def create
    pin = Pin.new(pin_params)
    if pin.save
      render json: pin, status: 201
    else
      render json: { errors: pin.errors }, status: 422
    end
  end

  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end

  private
    def restrict_access
      user = User.find_by(email: request.headers['x-user-email'])
      if login = user
        request.headers['x-api-token'] == user.api_token
      else
        false  
      end
      unless login
        render json: { errors: user.errors }, status: 401
      end
    end  
end