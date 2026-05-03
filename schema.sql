-- =============================================
-- joan_off Portfolio — Supabase SQL Schema v2
-- Run this in your Supabase SQL Editor
-- =============================================

-- PROJECTS TABLE
CREATE TABLE IF NOT EXISTS projects (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title       TEXT NOT NULL,
  description TEXT,
  tag         TEXT DEFAULT 'Web',
  techs       TEXT,
  github_url  TEXT,
  demo_url    TEXT,
  logo_url    TEXT,
  created_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- MESSAGES TABLE
CREATE TABLE IF NOT EXISTS messages (
  id         UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name       TEXT NOT NULL,
  email      TEXT NOT NULL,
  message    TEXT NOT NULL,
  read       BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- PROFILE TABLE (une seule ligne id=1)
CREATE TABLE IF NOT EXISTS profile (
  id          INT PRIMARY KEY DEFAULT 1,
  photo_url   TEXT,
  description TEXT,
  updated_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
INSERT INTO profile (id, description)
VALUES (1, 'Passionné par le code, je construis des interfaces web rapides, propres et bien pensées. Du front au back, j''aime créer des expériences qui ont du sens.')
ON CONFLICT (id) DO NOTHING;

-- SKILLS TABLE
CREATE TABLE IF NOT EXISTS skills (
  id         UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name       TEXT NOT NULL,
  logo_url   TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Langages par défaut
INSERT INTO skills (name, logo_url) VALUES
  ('HTML',       'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/html5/html5-original.svg'),
  ('CSS',        'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/css3/css3-original.svg'),
  ('Python',     'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg'),
  ('JavaScript', 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/javascript/javascript-original.svg'),
  ('Electron',   'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/electron/electron-original.svg')
ON CONFLICT DO NOTHING;

-- STORAGE BUCKET FOR LOGOS
INSERT INTO storage.buckets (id, name, public)
VALUES ('project-logos', 'project-logos', true)
ON CONFLICT DO NOTHING;

-- ─── RLS POLICIES ───

ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE profile  ENABLE ROW LEVEL SECURITY;
ALTER TABLE skills   ENABLE ROW LEVEL SECURITY;

-- Projects
CREATE POLICY "Public read projects" ON projects FOR SELECT USING (true);
CREATE POLICY "Allow all projects"   ON projects FOR ALL USING (true) WITH CHECK (true);

-- Messages
CREATE POLICY "Public insert messages" ON messages FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow all messages"     ON messages FOR ALL USING (true) WITH CHECK (true);

-- Profile
CREATE POLICY "Public read profile" ON profile FOR SELECT USING (true);
CREATE POLICY "Allow all profile"   ON profile FOR ALL USING (true) WITH CHECK (true);

-- Skills
CREATE POLICY "Public read skills" ON skills FOR SELECT USING (true);
CREATE POLICY "Allow all skills"   ON skills FOR ALL USING (true) WITH CHECK (true);

-- Storage
CREATE POLICY "Public read logos"    ON storage.objects FOR SELECT USING (bucket_id = 'project-logos');
CREATE POLICY "Anyone upload logos"  ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'project-logos');
CREATE POLICY "Anyone delete logos"  ON storage.objects FOR DELETE USING (bucket_id = 'project-logos');
