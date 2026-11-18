import { fail, redirect } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';
export const load: PageServerLoad = ({ locals }) => { if (locals.user) redirect(303, '/dashboard'); };
export const actions: Actions = { default: async ({ request, locals }) => {
 const form = await request.formData(); const email = String(form.get('email') ?? '').trim(); const password = String(form.get('password') ?? '');
 if (!email || !password) return fail(400, { error: 'Email dan kata sandi wajib diisi.', email });
 if (!locals.supabase) return fail(503, { error: 'Supabase belum dikonfigurasi. Lengkapi environment variables di file .env.', email });
 const { error } = await locals.supabase!.auth.signInWithPassword({ email, password });
 if (error) return fail(400, { error: 'Email atau kata sandi tidak cocok.', email });
 redirect(303, '/dashboard');
}};
