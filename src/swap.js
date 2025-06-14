<script>
	// 交換前のデータです
	var a = 10;
	var b = 20;

	// tに、aの値を入れて待避させます
	var t = a;
	// aに、bの値を入れます
	a = b;
	// bに、待避させたtの値を入れます
	b = t;

	// 結果を表示します
	alert("a="+a+",b="+b);
</script>
