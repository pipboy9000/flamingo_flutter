require('dotenv').config();
const fs = require('fs');
const path = require('path');
const OpenAI = require('openai');

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

const OUTPUT_DIR = './output/tests';
const AUDIO_DIR = path.join(OUTPUT_DIR, 'audio');

if (!fs.existsSync(AUDIO_DIR)) fs.mkdirSync(AUDIO_DIR, { recursive: true });

async function generateData(str) {

  try {

    const filename = `audioTest.mp3`;
    const filePath = path.join(AUDIO_DIR, filename);

    // 2. Generate the Audio
    // process.stdout.write(` 🔊 Audio: ${str}`);
    const mp3 = await openai.audio.speech.create({
      model: "gpt-4o-mini-tts",
      voice: "nova",
      instructions: "Speak naturally in Latin American Spanish.",
      input: str,
    });

    const buffer = Buffer.from(await mp3.arrayBuffer());
    await fs.promises.writeFile(filePath, buffer);
    console.log('✅');

  } catch (error) {
    console.error(`❌ ${error.message}`);
  }
}

generateData("La comida está deliciosa.");