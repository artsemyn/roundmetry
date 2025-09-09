import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { corsHeaders } from "../_shared/cors.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.44.2";

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { fileName } = await req.json();
    if (!fileName) {
      throw new Error("fileName is required");
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    const bucketName = "models";

    // 1. Unduh file GLB dari storage
    const { data: fileData, error: downloadError } = await supabase.storage
      .from(bucketName)
      .download(fileName);
    
    if (downloadError) throw downloadError;

    // Di Deno/TypeScript, kita tidak bisa menggunakan trimesh.
    // Fitur konversi ini memerlukan library yang kompleks yang tidak tersedia di Deno.
    // Solusi terbaik adalah membuat API terpisah (misal: dengan Python Flask/FastAPI)
    // atau menggunakan library sisi klien di Flutter.
    
    // Untuk sekarang, kita akan mensimulasikan prosesnya dan mengembalikan error
    // bahwa konversi di sisi server dengan Deno tidak dimungkinkan.
    throw new Error("Server-side GLB to STL conversion is not supported with Deno runtime. A separate Python service is recommended.");

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 500,
    });
  }
});