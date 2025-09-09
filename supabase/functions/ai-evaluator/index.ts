import { serve } from "https-deno.land/std@0.168.0/http/server.ts";
import { corsHeaders } from "../_shared/cors.ts";

const MODEL_NAME = "gemini-1.5-flash-latest"; 
const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY");
const API_URL = `https://generativelanguage.googleapis.com/v1beta/models/${MODEL_NAME}:generateContent?key=${GEMINI_API_KEY}`;

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { studentAnswer } = await req.json();

    // ** GANTI PROMPT LAMA DENGAN YANG BARU INI **
    const prompt = `
      TUGAS UTAMA: Evaluasi jawaban matematika siswa berdasarkan konteks soal yang diberikan.

      [KONTEKS SOAL]
      Sebuah kaleng susu berbentuk tabung memiliki jari-jari alas 7 cm dan tinggi 10 cm. Hitunglah volume kaleng tersebut! Gunakan nilai π = 22/7. Jawaban yang benar adalah 1540 cm³.

      [JAWABAN SISWA]
      "${studentAnswer}"

      [INSTRUKSI EVALUASI]
      1. Analisis jawaban siswa.
      2. Berikan skor [0 atau 1] untuk setiap kriteria berikut: [rumus benar, substitusi benar, perhitungan benar].
      3. Tulis umpan balik singkat dan ramah dalam Bahasa Indonesia yang menjelaskan skor tersebut.
      
      [FORMAT OUTPUT]
      Kembalikan HANYA sebuah objek JSON yang valid tanpa teks tambahan atau Markdown. Strukturnya harus persis seperti ini:
      {"skor": [1, 1, 0], "umpan_balik": "Penjelasan umpan balik di sini."}
    `;

    const geminiResponse = await fetch(API_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ contents: [{ parts: [{ text: prompt }] }] }),
    });

    if (!geminiResponse.ok) {
      throw new Error(`Gemini API error: ${await geminiResponse.text()}`);
    }

    const responseData = await geminiResponse.json();
    let feedbackText = responseData.candidates[0].content.parts[0].text;

    console.log("--- RESPONS MENTAH DARI GEMINI ---");
    console.log(feedbackText);
    console.log("---------------------------------");


    // --- PERBAIKAN DIMULAI DI SINI ---
    // Logika baru untuk mengekstrak JSON dari teks
    const jsonStartIndex = feedbackText.indexOf('{');
    const jsonEndIndex = feedbackText.lastIndexOf('}');
    
    if (jsonStartIndex !== -1 && jsonEndIndex !== -1) {
      // Ekstrak hanya bagian string di antara '{' dan '}'
      feedbackText = feedbackText.substring(jsonStartIndex, jsonEndIndex + 1);
    } else {
      throw new Error("Tidak ditemukan format JSON yang valid dalam respons AI.");
    }
    // --- AKHIR DARI PERBAIKAN ---

    const feedbackJson = JSON.parse(feedbackText);

    return new Response(JSON.stringify(feedbackJson), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 200,
    });

  } catch (error) {
    console.error("ERROR SAAT PARSING JSON ATAU LAINNYA:", error);
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 500,
    });
  }
});