using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;
namespace SecurityDoctor.Modles
{
    public class SendMobile
    {
        private readonly static string accountSid = "AC6a355ea8d0a2a46e2dc2126863b1674f";
        private readonly static string authToken = "b15edc518e838626005d193285dc92fd";
        public static string SendMoibileSms(string to)
        {
            string authCode = GenerateRandomInt(6);
            TwilioClient.Init(accountSid, authToken);
            CreateMessageOptions createMessageOptions = new(new PhoneNumber("+964" + to));
            var messageOptions = createMessageOptions;
            messageOptions.From = new PhoneNumber("+12516511226");
            messageOptions.Body = "رمز التحقق الخاص بك هو :" + authCode;
            MessageResource.Create(messageOptions);
            return authCode;
         }


        private static readonly Random random = new Random();
        private const string chars = "0123456789";

        private static string GenerateRandomInt(int length)
        {
            return new string(Enumerable.Repeat(chars, length)
              .Select(s => s[random.Next(s.Length)]).ToArray());
        }
    }
}
