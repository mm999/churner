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
      recipient_vars: {
        email => {
          'cardName' => cardName,
          'annualFee' => annualFee,
          'anniversaryDate' => anniversaryDate
        }
      },
      merge_vars: {
        'cardName' => cardName,
        'annualFee' => annualFee,
        'anniversaryDate' => anniversaryDate
      },
      async: true,
      inline_css: true,
      merge_language: handlebars
     )
  end
end