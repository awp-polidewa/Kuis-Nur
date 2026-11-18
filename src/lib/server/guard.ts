import { redirect } from '@sveltejs/kit';
import type { LayoutServerLoad } from '../../routes/(app)/$types';
export const requireUser: LayoutServerLoad = ({ locals }) => { if (!locals.user) redirect(303, '/login'); return { user: locals.user }; };
