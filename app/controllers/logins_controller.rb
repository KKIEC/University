class LoginsController < ApplicationController
  skip_before_action :require_user, only: %i[new create]

  def new; end

  def create
    student = Student.find_by(email: params[:logins][:email].downcase)
    response_handler(student)
  end

  def destroy
    session[:student_id] = nil
    flash[:notice] = 'You have successfully logged out.'
    redirect_to root_path
  end
end

private

def auth?(student)
  student.authenticate(params[:logins][:password])
end

def response_handler(student)
  if student && auth?(student)
    session[:student_id] = student.id
    flash[:notice] = 'You have successfully logged in.'
    redirect_to student
  else
    flash.now[:notice] = 'Something was wrong with your login information.'
    render 'new'
  end
end
