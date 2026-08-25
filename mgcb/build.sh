#!/usr/bin/env bash

source /app/mgcb/.env
touch /app/mgcb/.bash_history
rm -f /app/mgcb/config.files
touch /app/mgcb/config.files
rm -f /app/mgcb/config.shaders
touch /app/mgcb/config.shaders
echo "/workingDir:/app/csharp/code/InfiniminerClient/Content/" >> /app/mgcb/config.files
echo "/importer:TextureImporter" >> /app/mgcb/config.files
echo "/processor:TextureProcessor" >> /app/mgcb/config.files
cd /app/csharp/code/InfiniminerClient/Content/ && \
	find * -name "*.png" | while read png; \
		do echo "/build:$png" >> /app/mgcb/config.files; \
		done;

echo "/importer:FontDescriptionImporter" >> /app/mgcb/config.files
echo "/processor:FontDescriptionProcessor" >> /app/mgcb/config.files
cd /app/csharp/code/InfiniminerClient/Content/ && \
	find * -name "*.spritefont" | while read spritefont; \
		do echo "/build:$spritefont" >> /app/mgcb/config.files; \
		done;

echo "/importer:WavImporter" >> /app/mgcb/config.files
echo "/processor:SoundEffectProcessor" >> /app/mgcb/config.files
cd /app/csharp/code/InfiniminerClient/Content/ && \
	find * -name "*.wav" | while read wav; \
		do echo "/build:$wav" >> /app/mgcb/config.files; \
		done;

echo "/importer:Mp3Importer" >> /app/mgcb/config.files
echo "/processor:SongProcessor" >> /app/mgcb/config.files
cd /app/csharp/code/InfiniminerClient/Content/ && \
	find * -name "*.mp3" | while read mp3; \
		do echo "/build:$mp3" >> /app/mgcb/config.files; \
		done;

# shaders need to be compiled on windows because cross-compiling has proven
# to be a massive headache.
# yes, even using wine.
# yes, even using a wine docker image.
echo "/workingDir:../csharp/code/InfiniminerClient/Content" >> /app/mgcb/config.shaders
echo "/outputDir:../../../../bin/Content"
echo "/importer:EffectImporter" >> /app/mgcb/config.shaders
echo "/processor:EffectProcessor" >> /app/mgcb/config.shaders
cd /app/csharp/code/InfiniminerClient/Content/ && \
	find * -name "*.fx" | while read fx; \
		do echo "/build:$fx" >> /app/mgcb/config.shaders; \
		done;
mgcb /@:/app/mgcb/config /@:/app/mgcb/config.files
mgcb /OutputDir:/app/csharp/bin/net45/Content/ /@:/app/mgcb/config /@:/app/mgcb/config.files
