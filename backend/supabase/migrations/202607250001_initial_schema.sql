create table if not exists public.user_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  native_language text not null default 'Turkish',
  cefr_level text not null default 'A2',
  learning_goal text not null default 'dailyConversation',
  correction_intensity text not null default 'balanced',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.conversation_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  module text not null,
  topic text,
  started_at timestamptz not null default now(),
  finished_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.conversation_messages (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.conversation_sessions(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('user', 'assistant')),
  text text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.corrections (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.conversation_sessions(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  original text not null,
  highlighted_part text not null,
  corrected text not null,
  error_type text not null,
  explanation_tr text not null,
  natural_alternative text,
  pronunciation_tip text,
  severity text not null check (severity in ('low', 'medium', 'high')),
  created_at timestamptz not null default now()
);

create table if not exists public.lesson_reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  session_id uuid references public.conversation_sessions(id) on delete set null,
  module text not null,
  user_word_count integer not null default 0,
  unique_word_count integer not null default 0,
  grammar_score integer not null default 0,
  vocabulary_score integer not null default 0,
  fluency_score integer not null default 0,
  overall_score integer not null default 0,
  homework text,
  created_at timestamptz not null default now()
);

alter table public.user_profiles enable row level security;
alter table public.conversation_sessions enable row level security;
alter table public.conversation_messages enable row level security;
alter table public.corrections enable row level security;
alter table public.lesson_reports enable row level security;

create policy "Users can read own profile" on public.user_profiles
  for select using (auth.uid() = id);

create policy "Users can update own profile" on public.user_profiles
  for update using (auth.uid() = id);

create policy "Users can read own sessions" on public.conversation_sessions
  for select using (auth.uid() = user_id);

create policy "Users can insert own sessions" on public.conversation_sessions
  for insert with check (auth.uid() = user_id);

create policy "Users can read own messages" on public.conversation_messages
  for select using (auth.uid() = user_id);

create policy "Users can insert own messages" on public.conversation_messages
  for insert with check (auth.uid() = user_id);

create policy "Users can read own corrections" on public.corrections
  for select using (auth.uid() = user_id);

create policy "Users can insert own corrections" on public.corrections
  for insert with check (auth.uid() = user_id);

create policy "Users can read own reports" on public.lesson_reports
  for select using (auth.uid() = user_id);

create policy "Users can insert own reports" on public.lesson_reports
  for insert with check (auth.uid() = user_id);

