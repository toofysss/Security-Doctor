using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace SecurityDoctor.Modles
{
    public class FilesManager
    {

        public static async Task<string> Insertfiles(IFormFile File,string path)
        {
            var extension = "." + File.FileName.Split('.')[^1];
            string Filename = DateTime.Now.Ticks.ToString() + extension;
             var filepath = Path.Combine(Directory.GetCurrentDirectory(), path);

            if (!Directory.Exists(filepath))
            {
                Directory.CreateDirectory(filepath);
            }

            var exactpath = Path.Combine(Directory.GetCurrentDirectory(), path, Filename);
            using (var stream = new FileStream(exactpath, FileMode.Create))
            {
                await File.CopyToAsync(stream);
            }


            return Filename;
        }

        public static string RemoveFile(string oldImage,string path)
        {

            var extension = "." + oldImage.Split('.')[^1];
            string filename = DateTime.Now.Ticks.ToString() + extension;

            var filePath = Path.Combine(Directory.GetCurrentDirectory(), path);
 
            if (System.IO.File.Exists(Path.Combine(filePath, oldImage)))
            {
                System.IO.File.Delete(Path.Combine(filePath, oldImage));
            }
            return filename;

        }
    }
}
