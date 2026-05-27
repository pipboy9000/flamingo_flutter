require('dotenv').config();

const { ElevenLabsClient } = require("@elevenlabs/elevenlabs-js");
const fs = require('fs');
const path = require('path');
const { pipeline } = require('stream/promises');
const { Readable } = require('stream');
const OpenAI = require('openai');

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
const elevenlabs = new ElevenLabsClient({ apiKey: process.env.ELEVENLABS_API_KEY });

const CATEGORIES = [
  "Greetings & Basics", "Polite Phrases", "Emergency & Understanding",
  "Dining Out", "Travel & Navigation", "Numbers & Money",
  "Family & Relationships", "Daily Routine & Home", "Work & Professions",
  "Shopping & Clothing", "Health & The Body", "Feelings & Emotions",
  "Weather & Seasons", "Leisure & Hobbies", "Common Verbs & Actions"
];

const OUTPUT_DIR = './output';
const AUDIO_DIR = path.join(OUTPUT_DIR, 'audio');

if (!fs.existsSync(AUDIO_DIR)) fs.mkdirSync(AUDIO_DIR, { recursive: true });

async function writeAudioResponseToFile(response, filePath) {
  if (Buffer.isBuffer(response) || response instanceof Uint8Array) {
    await fs.promises.writeFile(filePath, response);
    return;
  }

  if (response && typeof response.arrayBuffer === 'function') {
    const audioBuffer = Buffer.from(await response.arrayBuffer());
    await fs.promises.writeFile(filePath, audioBuffer);
    return;
  }

  if (response && typeof response.pipe === 'function') {
    await pipeline(response, fs.createWriteStream(filePath));
    return;
  }

  if (response && typeof response.getReader === 'function') {
    await pipeline(Readable.fromWeb(response), fs.createWriteStream(filePath));
    return;
  }

  if (response && typeof response[Symbol.asyncIterator] === 'function') {
    const chunks = [];
    for await (const chunk of response) {
      chunks.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk));
    }
    await fs.promises.writeFile(filePath, Buffer.concat(chunks));
    return;
  }

  throw new TypeError(`Unsupported audio response type: ${typeof response}`);
}

async function generateData() {
  const dataset = [];

  for (const [idx, category] of CATEGORIES.entries()) {

    console.log(`\n🚀 Processing Category: ${category} (${idx + 1}/${CATEGORIES.length})`);

    try {
      // 1. Request 15 structured sentences with difficulty scaling
      const completion = await openai.chat.completions.create({
        model: "gpt-4o-mini",
        response_format: { type: "json_object" },
        messages: [{
          role: "system",
          content: `You are a linguistic expert creating a Hebrew learning dataset.
          Return a JSON object with a key "sentences" containing 15 entries.
          Each entry must have: 
          - "original": The Hebrew phrase. Make sure this is pure Hebrew without any English words.
          - "transliteration": Phonetic pronunciation.
          - "translated": English meaning.
          - "difficulty_level": Integer 1-5 (1=simple nouns, 5=complex sentences).
          - "breakdown": A Map/Object where keys are Hebrew words with transliteration in parenthesis and values are English meanings with information about: gender, plural/singular if needed. Ensure a mix of difficulty levels: 20% level 1, 40% level 2-3, 40% level 4-5 in ascending order. Avoid idioms or slang. Focus on practical, everyday phrases relevant to the category.`
        }, {
          role: "user",
          content: `Category: ${category}`
        }]
      });

      const { sentences } = JSON.parse(completion.choices[0].message.content);

      for (const item of sentences) {
        // Create a unique slug for the filename
        const slug = item.translated.toLowerCase().replace(/[^a-z]/g, '_').substring(0, 20);
        const filename = `${category.replace(/\s/g, '_').toLowerCase()}_${slug}.mp3`;
        const filePath = path.join(AUDIO_DIR, filename);

        // 2. Generate the Audio
        process.stdout.write(` 🔊 Audio: ${item.original} `);

        // FIX 1: Switched to ElevenLabs TTS for better Hebrew support and native Node Stream handling
        // const mp3 = await openai.audio.speech.create({
        //   model: "tts-1-hd",
        //   voice: "alloy",
        //   speed: 0.95,
        //   input: item.original, // Removed 'instructions' as it's unsupported
        // });
        // const buffer = Buffer.from(await mp3.arrayBuffer());
        // await fs.promises.writeFile(filePath, buffer);


        // FIX 2 & 3: Dynamically pass item.original and pipe the Node Stream natively
        const response = await elevenlabs.textToSpeech.convert(
          "XrExE9yKIg1WjnnlVkGX",
          {
            text: item.original,
            modelId: "eleven_v3",
            languageCode: "he"
          }
        );

        await writeAudioResponseToFile(response, filePath);

        console.log('✅');

        // 3. Store the record
        dataset.push({
          ...item,
          category,
          audio_path: `audio/${filename}`,
          proficiency: 0.0
        });
      }
    } catch (error) {
      console.error(`\n❌ Error in category ${category}:`, error);
    }
  }

  // 4. Save the Final JSON
  fs.writeFileSync(path.join(OUTPUT_DIR, 'dataset.json'), JSON.stringify(dataset, null, 2));

  console.log(`\n🎉 SUCCESS: ${dataset.length} items generated in /output`);
}

generateData();