FactoryBot.define do
  factory :email, class: OpenStruct do
    # Assumes Griddler.configure.to is :hash (default)
    from({ token: 'from_user',
           host: 'email.com',
           email: 'from_email@email.com',
           full: 'From User <from_user@email.com>',
           name: 'From User'
         })

    to [ { full: 'to_user@email.com',
           email: 'to_user@email.com',
           token: 'to_user',
           host: 'email.com',
           name: nil
         }
       ]

    subject 'subject'
    body 'body'
    attachments {[]}

    factory :email_with_excavator_tickets do
      attachments {
        [
          ActionDispatch::Http::UploadedFile.new({
            filename: 'ticket_1.xml',
            type: 'text/xml',
            tempfile: File.new("#{Rails.root}/spec/support/one_call/ga_georgia811/ticket_1.xml")
          }), # random file to test that only CSV files get parsed
          ActionDispatch::Http::UploadedFile.new({
            filename: 'excavator_tickets_2.csv',
            type: 'text/csv',
            tempfile: File.new("#{Rails.root}/spec/support/one_call/ga_georgia811/excavator_tickets_2.csv")
          })
        ]
      }
    end
  end

end
