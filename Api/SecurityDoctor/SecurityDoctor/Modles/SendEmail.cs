using MailKit.Net.Smtp;
using MimeKit;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SecurityDoctor.Modles
{
    public class SendEmail
    {
        private static readonly Random random = new Random();
        private const string chars = "0123456789";

        private static string GenerateRandomInt(int length)
        {
            return new string(Enumerable.Repeat(chars, length)
              .Select(s => s[random.Next(s.Length)]).ToArray());
        }


        public static  string SendEmailMessage(string Email)
        {
        
                string authCode = GenerateRandomInt(6);
                var email = new MimeMessage();
                email.From.Add(MailboxAddress.Parse("fa2535373@gmail.com"));
                email.To.Add(MailboxAddress.Parse(Email));
                email.Subject = "رمز التحقق";
                email.Body = new TextPart(MimeKit.Text.TextFormat.Html)
                {
                    Text = "رمز التحقق الخاص بك هو :" + authCode
                };
                using var smtp = new SmtpClient();
                smtp.Connect("smtp.gmail.com", 587, MailKit.Security.SecureSocketOptions.StartTls);
                smtp.Authenticate("fa2535373@gmail.com", "oeefbkrtklbfeata");
                smtp.Send(email);
                smtp.Disconnect(true);
                return authCode;
  
        }

      
    }
}
