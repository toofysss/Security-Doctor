using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Net.Http;
using System.Text;

namespace SecurityDoctor.Modles
{
    public class SendNotification
    {
        private readonly static string key = "AAAANnOEWdw:APA91bHg4k_49pct8jMmNP9ltpuhbaqH9ClOLKPi6ZOKs7fqGGkUIdstFbdI_CDBRRDM4hBST386OjHOsVEEWrycF9I40gPeVPN4j6GV6uUqk79jMfhKzF6yqQot6uG9yBe0-FZxn5qA";
          private static HttpClient _client = new HttpClient();
         public static async Task  SendNotificationS(int userId ,string body,string title)
        {
                 _client.DefaultRequestHeaders.TryAddWithoutValidation("Authorization", "key=" + key);
                var bodyString = "{\"to\": \"/topics/"+ userId + "\", \"notification\": { \"title\": \"" + title + "\", \"body\": \"" + body + "\" }}";
                var content = new StringContent(bodyString, Encoding.UTF8, "application/json");
                var response = await _client.PostAsync("https://fcm.googleapis.com/fcm/send", content);
                response.EnsureSuccessStatusCode();      
        }
 
    }
}
