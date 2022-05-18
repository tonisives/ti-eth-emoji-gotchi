<script>
	import WalletConnect from '$lib/WalletConnect.svelte';
	import EmojiGotchi from '../lib/EmojiGotchi.svelte';

	import EmojiGotchiAbi from '../contracts/EmojiGotchi.json';
	const contractAddr = '0x7621369d0433c8d7baaff647e5551472c0bfacc7';

	export let web3Props = {
		provider: null,
		signer: null,
		account: null,
		chainId: null,
		contract: null
	};
</script>

<h1>My EmojiGotchi</h1>

{#if !web3Props.account}
	<WalletConnect bind:web3Props {contractAddr} contractAbi={EmojiGotchiAbi} />
{:else}
	<EmojiGotchi bind:web3Props />
{/if}
