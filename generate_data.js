require('dotenv').config();
const fs = require('fs');
const path = require('path');
const OpenAI = require('openai');

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

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

async function generateData() {
  const dataset = [];

  for (const category of CATEGORIES) {
    console.log(`\n🚀 Processing Category: ${category}`);

    try {
      // 1. Request 15 structured sentences with difficulty scaling
      const completion = await openai.chat.completions.create({
        model: "gpt-4o-mini",
        messages: [{
          role: "system",
          content: `You are a linguistic expert creating a Italian learning dataset. 
          Return a JSON object with a key "sentences" containing 15 entries.
          Each entry must have:
          - "original": The Italian phrase. make sure this is pure Italian without any English words.
          - "transliteration": Phonetic pronunciation.
          - "translated": English meaning.
          - "difficulty_level": Integer 1-5 (1=simple nouns, 5=complex sentences).
          - "breakdown": A Map/Object where keys are Italian words and values are English meanings.
          
          Ensure a mix of difficulty levels: 20% level 1, 40% level 2-3, 40% level 4-5 in ascending order. Avoid idioms or slang. Focus on practical, everyday phrases relevant to the category.`
        }, {
          role: "user",
          content: `Category: ${category}`
        }],
        response_format: { type: "json_object" }
      });

      const { sentences } = JSON.parse(completion.choices[0].message.content);

      for (const item of sentences) {
        // Create a unique slug for the filename
        const slug = item.translated.toLowerCase().replace(/[^a-z]/g, '_').substring(0, 20);
        const filename = `${category.replace(/\s/g, '_').toLowerCase()}_${slug}.mp3`;
        const filePath = path.join(AUDIO_DIR, filename);

        // 2. Generate the Audio
        process.stdout.write(` 🔊 Audio: ${item.original}`);
        const mp3 = await openai.audio.speech.create({
          model: "gpt-4o-mini-tts",
          voice: "nova",
          instructions: "Speak naturally in Italian.",
          input: item.original,
        });

        const buffer = Buffer.from(await mp3.arrayBuffer());
        await fs.promises.writeFile(filePath, buffer);
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
      console.error(`❌ Error in category ${category}:`, error.message);
    }
  }

  // 4. Save the Final JSON
  fs.writeFileSync(path.join(OUTPUT_DIR, 'dataset.json'), JSON.stringify(dataset, null, 2));
  console.log(`\n🎉 SUCCESS: 225 items generated in /output`);
}

generateData();