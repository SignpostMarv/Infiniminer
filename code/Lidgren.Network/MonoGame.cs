using Lidgren.Network;

using Microsoft.Xna.Framework;

namespace Lidgren.Network.MonoGame
{
    public static class MonoGameExtensions
    {
        public static Vector3 ReadVector3(this NetBuffer msgBuffer)
        {
            return new Vector3(
                msgBuffer.ReadFloat(),
                msgBuffer.ReadFloat(),
                msgBuffer.ReadFloat()
            );
        }

        public static void Write(this NetBuffer msgBuffer, Vector3 vector)
        {
            msgBuffer.Write(vector.X);
            msgBuffer.Write(vector.Y);
            msgBuffer.Write(vector.Z);
        }
    }
}
