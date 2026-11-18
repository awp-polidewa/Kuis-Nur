<script lang="ts">
	type IconName =
		| 'home'
		| 'plus'
		| 'clock'
		| 'grid'
		| 'bar-chart'
		| 'exit'
		| 'arrow'
		| 'chevron-right'
		| 'chevron-down'
		| 'warning-shield'
		| 'cash'
		| 'search'
		| 'delete'
		| 'sparkles'
		| 'coins'
		| 'refresh';

	let { name, size = 18, class: className = '' }: { name: IconName; size?: number; class?: string } = $props();
</script>

<img
	class={className}
	src={`/icons8/${name}.png`}
	width={size}
	height={size}
	alt=""
	aria-hidden="true"
	loading="lazy"
/>
