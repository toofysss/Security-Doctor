using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace SecurityDoctor.Modles
{
    public class EncryptManager
    {
        private readonly static string key = "ashproghelpdotnetmania2022key123";
        public static string Encrypt(string text)
        {
            byte[] iv = new byte[16];
            byte[] array;
            using (Aes aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(key);
                aes.IV = iv;
                ICryptoTransform encrypt = aes.CreateEncryptor(aes.Key, aes.IV);
                using (MemoryStream ms = new())
                {
                    using CryptoStream cryptoStream = new(ms, encrypt, CryptoStreamMode.Write);
                    using (StreamWriter streamWriter = new(cryptoStream))
                    {
                        streamWriter.Write(text);
                    }
                    array = ms.ToArray();
                }
                return Convert.ToBase64String(array);
            };
        }

        public static string Decrypt(string text)
        {
            byte[] iv = new byte[16];
            byte[] buffer=Convert.FromBase64String(text);
            using (Aes aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(key);
                aes.IV = iv;
                ICryptoTransform decrypt = aes.CreateDecryptor(aes.Key, aes.IV);
                using MemoryStream ms = new(buffer);
                using CryptoStream cryptoStream = new(ms, decrypt, CryptoStreamMode.Read);
                using StreamReader streamWriter = new((cryptoStream));
                return streamWriter.ReadToEnd();
            };
        }

    }
}
