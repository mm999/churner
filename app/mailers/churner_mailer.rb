class ChurnerMailer < MandrillMailer::TemplateMailer

  def anniversary(email, cardName, annualFee, anniversaryDate)
    mandrill_mail(
      template: 'anniversary',
      to: email,
      vars: {
        'cardName' => cardName,
        'annualFee' => annualFee,
        'anniversaryDate' => anniversaryDate
      },
      async: true
     )
  end
end