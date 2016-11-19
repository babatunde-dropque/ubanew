require 'test_helper'

class InterviewMailerTest < ActionMailer::TestCase
  test "interview_invite" do
    mail = InterviewMailer.interview_invite
    assert_equal "Interview invite", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "shortlist" do
    mail = InterviewMailer.shortlist
    assert_equal "Shortlist", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "reject" do
    mail = InterviewMailer.reject
    assert_equal "Reject", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
