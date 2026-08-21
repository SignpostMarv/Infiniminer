extern alias Monogame;

using Lidgren.Network;

using Vector3 = Monogame::Microsoft.Xna.Framework.Vector3;

namespace Infiniminer
{
    public class XnaAlongsideMonoGame
    {
        public static Vector3 Vector3FromMessageBuffer(
            NetBuffer msgBuffer
        )
        {
            return new Vector3(
                msgBuffer.ReadFloat(),
                msgBuffer.ReadFloat(),
                msgBuffer.ReadFloat()
            );
        }

        public static void Vector3ToMessageBuffer(
            NetBuffer msgBuffer,
            Vector3 vector
        )
        {
            msgBuffer.Write(vector.X);
            msgBuffer.Write(vector.Y);
            msgBuffer.Write(vector.Z);
        }
    }
}
