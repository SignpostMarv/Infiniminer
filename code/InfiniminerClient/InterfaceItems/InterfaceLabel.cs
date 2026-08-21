extern alias Monogame;


using Microsoft.Xna.Framework;

using Color = Monogame::Microsoft.Xna.Framework.Color;
using GraphicsDevice = Monogame::Microsoft.Xna.Framework.Graphics.GraphicsDevice;
using SpriteBatch = Monogame::Microsoft.Xna.Framework.Graphics.SpriteBatch;
using SpriteFont = Monogame::Microsoft.Xna.Framework.Graphics.SpriteFont;
using Vector2 = Monogame::Microsoft.Xna.Framework.Vector2;

namespace InterfaceItems
{
    class InterfaceLabel : InterfaceElement
    {
        public InterfaceLabel()
        {
        }

        public InterfaceLabel(Infiniminer.InfiniminerGame gameInstance)
        {
            uiFont = gameInstance.Content.Load<SpriteFont>("font_04b08");
        }

        public InterfaceLabel(Infiniminer.InfiniminerGame gameInstance, Infiniminer.PropertyBag pb)
        {
            uiFont = gameInstance.Content.Load<SpriteFont>("font_04b08");
            _P = pb;
        }

        public override void Render(GraphicsDevice graphicsDevice)
        {
            if (visible&&text!="")
            {
                SpriteBatch spriteBatch = new SpriteBatch(graphicsDevice);
                spriteBatch.Begin();

                spriteBatch.DrawString(uiFont, text, new Vector2(size.X, size.Y), Color.White);
                spriteBatch.End();
            }
        }
    }
}
