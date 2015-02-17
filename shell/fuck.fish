# from a comment on: https://gist.github.com/namuol/9122237

function flip
	perl -C3 -Mutf8 -lpe '$_=reverse;y/a-zA-Z.['\'',({?!\"<_;‿⁅∴\r/ɐqɔpǝɟƃɥıɾʞ|ɯuodbɹsʇnʌʍxʎzɐqɔpǝɟƃɥıɾʞ|ɯuodbɹsʇnʌʍxʎz˙],'\'')}¿¡,>‾؛⁀⁆∵\n/' <<< "$argv[1]"
end

function fuck
	if test $# == 1
		killall -9 "$argv[1]" && echo -e "\n (╯°□°）╯︵$(flip "$argv[1]")\n"
	else
		killall -9 "$argv[2]" && echo -e "\n (╯°□°）╯︵$(flip "$argv[2]")\n"
	end
end
