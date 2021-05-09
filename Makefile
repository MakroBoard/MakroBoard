# clean-linux data 
clean-linux_data: clean-linux_clientdata clean-linux_hostdata


clean-linux_clientdata:
	rm -rf ~/.local/share/MakroBoardClient

clean-linux_hostdata:
	rm -rf ~/.config/MakroBoard


