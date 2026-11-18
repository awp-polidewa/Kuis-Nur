import { createServerClient } from '@supabase/ssr';
import type { Handle } from '@sveltejs/kit';
import { env } from '$env/dynamic/public';

export const handle: Handle = async ({ event, resolve }) => {
	const url = env.PUBLIC_SUPABASE_URL;
	const key = env.PUBLIC_SUPABASE_ANON_KEY;
	const supabase = url && key ? createServerClient(url, key, {
		cookies: { getAll: () => event.cookies.getAll(), setAll: (cookies) => cookies.forEach(({ name, value, options }) => event.cookies.set(name, value, { ...options, path: '/' })) }
	}) : null;
	event.locals.supabase = supabase;
	const auth = supabase ? await supabase.auth.getClaims() : null;
	const claims = auth?.data?.claims;
	event.locals.user = claims?.sub
		? { id: claims.sub, email: typeof claims.email === 'string' ? claims.email : undefined }
		: null;
	return resolve(event, { filterSerializedResponseHeaders: (name) => name === 'content-range' || name === 'x-supabase-api-version' });
};
