<script>
	export let status;
</script>

<div class="status" style={`width: ${status}%`} />

<style>
	.status {
		height: 8px;
		background: #ffc107;
		width: 33%;
	}
</style>
