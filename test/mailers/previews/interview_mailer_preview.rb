# Preview all emails at http://localhost:3000/rails/mailers/interview_mailer
class InterviewMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/interview_mailer/interview_invite
  def interview_invite
    InterviewMailer.interview_invite(Interview.first, "mustaphaalade@gmail.com", "dropque.com")
  end

  # Preview this email at http://localhost:3000/rails/mailers/interview_mailer/shortlist
  def shortlist
    InterviewMailer.shortlist
  end

  # Preview this email at http://localhost:3000/rails/mailers/interview_mailer/reject
  def reject
    InterviewMailer.reject
  end

end
