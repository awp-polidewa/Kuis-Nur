import type { SupabaseClient, User } from '@supabase/supabase-js';
declare global {
	namespace App {
		interface Locals { supabase: SupabaseClient | null; user: Pick<User, 'id' | 'email'> | null }
		interface PageData { user?: Pick<User, 'id' | 'email'> | null }
	}
}
export {};
