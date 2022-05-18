<script>
	import Face from './Face.svelte';
	import Bar from './Bar.svelte';

	export let web3Props = {
		provider: null,
		signer: null,
		account: null,
		chainId: null,
		contract: null
	};
	$: image = '';
	$: hunger = 0;
	$: enrichment = 0;
	$: happiness = 0;

	const getMyGotchi = async () => {
		let currentGotchi = await web3Props.contract.myGotchi();
		happiness = await currentGotchi[0].toNumber();
		hunger = await currentGotchi[1].toNumber();
		enrichment = await currentGotchi[2].toNumber();
		image = await currentGotchi[4];

		web3Props.contract.on('EmojiUpdated', async () => {
			currentGotchi = await web3Props.contract.myGotchi();
			happiness = await currentGotchi[0].toNumber();
			hunger = await currentGotchi[1].toNumber();
			enrichment = await currentGotchi[2].toNumber();
			image = await currentGotchi[4];
		});
	};
	getMyGotchi();
</script>

<div>
	<Face {image} />
</div>
<div>
	Hunger: {hunger}
	<br />
	<Bar bind:status={hunger} />
	<button on:click={() => web3Props.contract.feed()}>Feed</button>
</div>
<div>
	Enrichment: {enrichment}
	<br />
	<Bar bind:status={enrichment} />
	<button on:click={() => web3Props.contract.play()}>Play</button>
</div>
<div>
	Happiness: {happiness}
	<br />
	<Bar bind:status={happiness} />
</div>

<style>
	div {
		width: 33%;
	}
</style>
