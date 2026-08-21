extern alias Monogame;

using StateMasher;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

using Color = Monogame::Microsoft.Xna.Framework.Color;
using GameTime = Monogame::Microsoft.Xna.Framework.GameTime;
using BlendState = Monogame::Microsoft.Xna.Framework.Graphics.BlendState;
using GraphicsDevice = Monogame::Microsoft.Xna.Framework.Graphics.GraphicsDevice;
using SpriteBatch = Monogame::Microsoft.Xna.Framework.Graphics.SpriteBatch;
using SpriteFont = Monogame::Microsoft.Xna.Framework.Graphics.SpriteFont;
using SpriteSortMode = Monogame::Microsoft.Xna.Framework.Graphics.SpriteSortMode;
using Texture2D = Monogame::Microsoft.Xna.Framework.Graphics.Texture2D;
using Point = Monogame::Microsoft.Xna.Framework.Point;
using Rectangle = Monogame::Microsoft.Xna.Framework.Rectangle;
using Vector2 = Monogame::Microsoft.Xna.Framework.Vector2;

namespace Infiniminer.States
{
    public class TeamSelectionState : State
    {
        Texture2D texMenu;
        Rectangle drawRect;
        string nextState = null;
        SpriteFont uiFont;
        bool canCancel = false;

        ClickRegion[] clkTeamMenu = new ClickRegion[2] {
            new ClickRegion(new Rectangle(229,156,572,190), "red"),
            new ClickRegion(new Rectangle(135,424,761,181), "blue")/*,
            new ClickRegion(new Rectangle(0,0,0,0), "cancel")
            */
        };

        public override void OnEnter(string oldState)
        {
            _SM.IsMouseVisible = true;

            texMenu = _SM.Content.Load<Texture2D>("menus/tex_menu_team");

            drawRect = new Rectangle(_SM.GraphicsDevice.Viewport.Width / 2 - 1024 / 2,
                                     _SM.GraphicsDevice.Viewport.Height / 2 - 768 / 2,
                                     1024,
                                     1024);

            uiFont = _SM.Content.Load<SpriteFont>("font_04b08");

            if (oldState == "Infiniminer.States.MainGameState")
                canCancel = true;
        }

        public override void OnLeave(string newState)
        {

        }

        public override string OnUpdate(GameTime gameTime, KeyboardState keyState, MouseState mouseState)
        {
            // Do network stuff.
            (_SM as InfiniminerGame).UpdateNetwork(gameTime);

            return nextState;
        }

        public override void OnRenderAtEnter(GraphicsDevice graphicsDevice)
        {

        }

        public void QuickDrawText(SpriteBatch spriteBatch, string text, int y, Color color)
        {
            spriteBatch.DrawString(uiFont, text, new Vector2(_SM.GraphicsDevice.Viewport.Width / 2 - uiFont.MeasureString(text).X / 2, drawRect.Y + y), color);
        }

        public override void OnRenderAtUpdate(GraphicsDevice graphicsDevice, GameTime gameTime)
        {
            int redTeamCount = 0, blueTeamCount = 0;
            foreach (Player p in _P.playerList.Values)
            {
                if (p.Team == PlayerTeam.Red)
                    redTeamCount += 1;
                else if (p.Team == PlayerTeam.Blue)
                    blueTeamCount += 1;
            }

            SpriteBatch spriteBatch = new SpriteBatch(graphicsDevice);
            spriteBatch.Begin(SpriteSortMode.Deferred, BlendState.AlphaBlend);
            spriteBatch.Draw(texMenu, drawRect, Color.White);
            QuickDrawText(spriteBatch, "" + redTeamCount + " PLAYERS", 360, _P.red);//Defines.IM_RED);
            QuickDrawText(spriteBatch, "" + blueTeamCount + " PLAYERS", 620, _P.blue);//Defines.IM_BLUE);
            spriteBatch.End();
        }

        public override void OnKeyDown(Keys key)
        {
            if (key == Keys.Escape && canCancel)
                nextState = "Infiniminer.States.MainGameState";
        }

        public override void OnKeyUp(Keys key)
        {

        }

        public override void OnMouseDown(MouseButton button, int x, int y)
        {
            x -= drawRect.X;
            y -= drawRect.Y;
            switch (ClickRegion.HitTest(clkTeamMenu, new Point(x, y)))
            {
                case "red":
                    if (_P.playerTeam == PlayerTeam.Red && canCancel)
                        nextState = "Infiniminer.States.MainGameState";
                    else
                    {
                        _P.SetPlayerTeam(PlayerTeam.Red);
                        nextState = "Infiniminer.States.ClassSelectionState";
                    }
                    _P.PlaySound(InfiniminerSound.ClickHigh);
                    break;
                case "blue":
                    if (_P.playerTeam == PlayerTeam.Blue && canCancel)
                        nextState = "Infiniminer.States.MainGameState";
                    else
                    {
                        _P.SetPlayerTeam(PlayerTeam.Blue);
                        nextState = "Infiniminer.States.ClassSelectionState";
                    }
                    _P.PlaySound(InfiniminerSound.ClickHigh);
                    break;
                case "cancel":
                    if (canCancel)
                    {
                        nextState = "Infiniminer.States.MainGameState";
                        _P.PlaySound(InfiniminerSound.ClickHigh);
                    }
                    break;
            }
        }

        public override void OnMouseUp(MouseButton button, int x, int y)
        {

        }

        public override void OnMouseScroll(int scrollDelta)
        {

        }
    }
}
