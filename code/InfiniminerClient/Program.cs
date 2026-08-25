using System;
using System.IO;

using Aprillz.MewUI;

namespace Infiniminer
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {
            using (InfiniminerGame game = new InfiniminerGame(args))
            {
                try
                {
                    game.Run();
                }
                catch (Exception e)
                {
                    string log = e.Message + "\r\n\r\n" + e.StackTrace;

                    File.WriteAllText(
                        "InfiniminerClient.crash.log",
                        log
                    );
                }
            }
        }
    }
}

