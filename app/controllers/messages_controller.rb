class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy, :revive]
  before_action :mark_as_read, only: :show

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
    @messages = if params[:path] == 'inbox'
      current_user.received_messages.undeleted.by_time
    elsif params[:path] == 'sent'
      current_user.sent_messages.by_time
    elsif params[:path] == 'trash'
      current_user.received_messages.deleted.by_time
    else
      redirect_to messages_path(path: :inbox)
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
    @message.recepient_email = params[:recepient_email]
    @message.subject = params[:subject]
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    recepient = User.find_by email: params[:message][:recepient_email]

    @message = Message.new(message_params)
    @message.sender = current_user
    @message.recepient = recepient

    respond_to do |format|
      if @message.save
        format.html { redirect_to messages_path(path: :sent), notice: 'Письмо успешно отправлено.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.update(deleted: true)
    respond_to do |format|
      format.html { redirect_to messages_url(path: :trash), notice: 'Письмо перемещено в корзину.' }
      format.json { head :no_content }
    end
  end

  def revive
    @message.update(deleted: false)
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Письмо восстановлено из корзины.' }
      format.json { head :no_content }
    end
  end

  def empty_trash
    current_user.received_messages.deleted.by_time.delete_all
    redirect_to messages_url(path: :trash), notice: 'Корзина очищена.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:subject, :text, :recepient_email)
    end

    def mark_as_read
      if current_user == @message.recepient
        @message.update(read: true)
      end
    end
end
