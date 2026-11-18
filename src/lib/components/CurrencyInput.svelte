<script lang="ts">
	let {
		name,
		value = $bindable<number | null>(null),
		min = 0,
		max = Number.MAX_SAFE_INTEGER,
		required = false,
		placeholder = '0'
	}: {
		name: string;
		value?: number | null;
		min?: number;
		max?: number;
		required?: boolean;
		placeholder?: string;
	} = $props();

	let display = $state(value == null ? '' : grouped(value));

	function grouped(amount: number) {
		return new Intl.NumberFormat('id-ID', { maximumFractionDigits: 0 }).format(amount);
	}

	function digitsOnly(text: string) {
		return text.replace(/\D/g, '');
	}

	function setAmount(digits: string, caretDigits: number, input: HTMLInputElement) {
		const normalized = digits.replace(/^0+(?=\d)/, '');
		const parsed = normalized ? Number(normalized) : null;
		value = parsed !== null && Number.isSafeInteger(parsed) ? parsed : null;
		display = parsed === null ? '' : grouped(parsed);

		requestAnimationFrame(() => {
			if (!input.isConnected || document.activeElement !== input) return;
			input.setCustomValidity(parsed !== null && parsed < min ? `Nominal minimal ${grouped(min)} rupiah.` : parsed !== null && parsed > max ? `Nominal maksimal ${grouped(max)} rupiah.` : '');
			let position = 0;
			let seen = 0;
			while (position < display.length && seen < caretDigits) {
				if (/\d/.test(display[position])) seen++;
				position++;
			}
			input.setSelectionRange(position, position);
		});
	}

	function handleInput(event: Event) {
		const input = event.currentTarget as HTMLInputElement;
		const caret = input.selectionStart ?? input.value.length;
		setAmount(digitsOnly(input.value), digitsOnly(input.value.slice(0, caret)).length, input);
	}

	function handleKeydown(event: KeyboardEvent) {
		const input = event.currentTarget as HTMLInputElement;
		const start = input.selectionStart ?? 0;
		const end = input.selectionEnd ?? start;
		if (start !== end) return;

		const backspaceAcrossSeparator = event.key === 'Backspace' && input.value[start - 1] === '.';
		const deleteAcrossSeparator = event.key === 'Delete' && input.value[start] === '.';
		if (!backspaceAcrossSeparator && !deleteAcrossSeparator) return;

		event.preventDefault();
		const digits = digitsOnly(input.value);
		const digitIndex = digitsOnly(input.value.slice(0, start)).length;
		const removeAt = backspaceAcrossSeparator ? digitIndex - 1 : digitIndex;
		const updated = digits.slice(0, removeAt) + digits.slice(removeAt + 1);
		setAmount(updated, backspaceAcrossSeparator ? digitIndex - 1 : digitIndex, input);
	}
</script>

<span class="currency-input">
	<span class="prefix" aria-hidden="true">Rp</span>
	<input
		type="text"
		inputmode="numeric"
		autocomplete="off"
		spellcheck="false"
		value={display}
		oninput={handleInput}
		onkeydown={handleKeydown}
		{placeholder}
		{required}
	/>
	<input type="hidden" {name} value={value ?? ''} />
</span>

<style>
	.currency-input{display:flex;align-items:center;gap:8px;width:100%;height:48px;box-sizing:border-box;padding:0 12px;background:var(--surface);border:1px solid var(--border);border-radius:12px;color:var(--ink)}
	.prefix{font-weight:700;flex:none}
	.currency-input input[type=text]{min-width:0;flex:1;width:100%;height:100%;min-height:0;padding:0;border:0;border-radius:0;background:transparent;box-shadow:none;outline:none;font:inherit;text-align:left}
	.currency-input input[type=hidden]{display:none}
	.currency-input:focus-within{outline:2px solid var(--purple);outline-offset:1px}
</style>
