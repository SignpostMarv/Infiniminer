extern alias Monogame;

using System;
using Microsoft.Xna.Framework;

using Color = Monogame::Microsoft.Xna.Framework.Color;
using GameTime = Monogame::Microsoft.Xna.Framework.GameTime;
using GameWindow = Monogame::Microsoft.Xna.Framework.GameWindow;
using DepthStencilState = Monogame::Microsoft.Xna.Framework.Graphics.DepthStencilState;
using Effect = Monogame::Microsoft.Xna.Framework.Graphics.Effect;
using EffectPass = Monogame::Microsoft.Xna.Framework.Graphics.EffectPass;
using GraphicsDevice = Monogame::Microsoft.Xna.Framework.Graphics.GraphicsDevice;
using PrimitiveType = Monogame::Microsoft.Xna.Framework.Graphics.PrimitiveType;
using RasterizerState = Monogame::Microsoft.Xna.Framework.Graphics.RasterizerState;
using SamplerState = Monogame::Microsoft.Xna.Framework.Graphics.SamplerState;
using Texture2D = Monogame::Microsoft.Xna.Framework.Graphics.Texture2D;
using VertexDeclaration = Monogame::Microsoft.Xna.Framework.Graphics.VertexDeclaration;
using VertexPositionTexture = Monogame::Microsoft.Xna.Framework.Graphics.VertexPositionTexture;
using Matrix = Monogame::Microsoft.Xna.Framework.Matrix;
using Vector2 = Monogame::Microsoft.Xna.Framework.Vector2;
using Vector3 = Monogame::Microsoft.Xna.Framework.Vector3;

namespace Infiniminer
{
    public class SkyplaneEngine
    {
        InfiniminerGame gameInstance;
        PropertyBag _P;
        Texture2D texNoise;
        Random randGen;
        VertexPositionTexture[] vertices;
        Effect effect;
        VertexDeclaration vertexDeclaration;
        float effectTime = 0;

        public SkyplaneEngine(InfiniminerGame gameInstance)
        {
            this.gameInstance = gameInstance;

            // Generate a noise texture.
            randGen = new Random();
            texNoise = new Texture2D(gameInstance.GraphicsDevice, 64, 64);
            uint[] noiseData = new uint[64*64];
            for (int i = 0; i < 64 * 64; i++)
                if (randGen.Next(32) == 0)
                    noiseData[i] = Color.White.PackedValue;
                else
                    noiseData[i] = Color.Black.PackedValue;
            texNoise.SetData(noiseData);

            // Load the effect file.
            effect = gameInstance.Content.Load<Effect>("effect_skyplane");

            // Create our vertices.
            vertexDeclaration = VertexPositionTexture.VertexDeclaration;
            vertices = new VertexPositionTexture[6];
            vertices[0] = new VertexPositionTexture(new Vector3(-210, 100, -210), new Vector2(0, 0));
            vertices[1] = new VertexPositionTexture(new Vector3(274, 100, -210), new Vector2(1, 0));
            vertices[2] = new VertexPositionTexture(new Vector3(274, 100, 274), new Vector2(1, 1));
            vertices[3] = new VertexPositionTexture(new Vector3(-210, 100, -210), new Vector2(0, 0));
            vertices[4] = new VertexPositionTexture(new Vector3(274, 100, 274), new Vector2(1, 1));
            vertices[5] = new VertexPositionTexture(new Vector3(-210, 100, 274), new Vector2(0, 1));
        }

        public void Update(GameTime gameTime)
        {
            effectTime = (float)gameTime.TotalGameTime.TotalSeconds;
        }

        public void Render(GraphicsDevice graphicsDevice)
        {
            // If we don't have _P, grab it from the current gameInstance.
            // We can't do this in the constructor because we are created in the property bag's constructor!
            if (_P == null)
                _P = gameInstance.propertyBag;

            // Draw the skybox.
            Matrix viewMatrix = _P.playerCamera.ViewMatrix;
            Matrix projectionMatrix = _P.playerCamera.ProjectionMatrix;

            effect.CurrentTechnique = effect.Techniques["Skyplane"];
            effect.Parameters["xWorld"].SetValue(Matrix.Identity);
            effect.Parameters["xView"].SetValue(viewMatrix);
            effect.Parameters["xProjection"].SetValue(projectionMatrix);
            effect.Parameters["xTexture"].SetValue(texNoise);
            effect.Parameters["xTime"].SetValue(effectTime);
            foreach (EffectPass pass in effect.CurrentTechnique.Passes)
            {
                pass.Apply();
                graphicsDevice.SamplerStates[0] = SamplerState.PointClamp;
                graphicsDevice.RasterizerState = RasterizerState.CullNone;
                graphicsDevice.DepthStencilState = DepthStencilState.None;
                graphicsDevice.DrawUserPrimitives(PrimitiveType.TriangleList, vertices, 0, vertices.Length / 3);
                graphicsDevice.DepthStencilState = DepthStencilState.Default;
            }
        }
    }
}
