/*
 * This file implements a Character ROM for translating ASCII
 * character codes into 8x16 pixel image.
 *
 * The input to the module is:
 *  1) 8 bit ASCII code,
 *  2) column select, 0..7, which indicates which of the 8 pixels of the character
 *     image will be returned
 *  3) row select, 0..15, which indicates which of the 16 rows of pixels of the character
 *     image will be returned
 */

module pc_vga_8x16 (
	input	[2:0]	col,
	input	[3:0]	row,
	input	[7:0]	ascii,
	output	pixel
);

reg [16383:0] charrom = {
256'h00000000000000000000000000000000000000007e818199bd8181a5817e0000, 256'h000000007effffe7c3ffffdbff7e00000000000010387cfefefefe6c00000000, 
256'h000000000010387cfe7c381000000000000000003c1818e7e7e73c3c18000000, 256'h000000003c18187effff7e3c18000000000000000000183c3c18000000000000, 
256'hffffffffffffe7c3c3e7ffffffffffff00000000003c664242663c0000000000, 256'hffffffffffc399bdbd99c3ffffffffff0000000078cccccccc78321a0e1e0000, 
256'h0000000018187e183c666666663c000000000000e0f070303030303f333f0000, 256'h000000c0e6e767636363637f637f0000000000001818db3ce73cdb1818000000, 
256'h0000000080c0e0f0f8fef8f0e0c080000000000002060e1e3efe3e1e0e060200, 256'h0000000000183c7e1818187e3c18000000000000666600666666666666660000, 
256'h000000001b1b1b1b1b7bdbdbdb7f00000000007cc60c386cc6c66c3860c67c00, 256'h00000000fefefefe0000000000000000000000007e183c7e1818187e3c180000, 
256'h00000000181818181818187e3c18000000000000183c7e181818181818180000, 256'h000000000000180cfe0c1800000000000000000000003060fe60300000000000, 
256'h000000000000fec0c0c00000000000000000000000002466ff66240000000000, 256'h0000000000fefe7c7c3838100000000000000000001038387c7cfefe00000000, 

256'h00000000000000000000000000000000000000001818001818183c3c3c180000, 256'h00000000000000000000002466666600000000006c6cfe6c6c6cfe6c6c000000, 
256'h000018187cc68606067cc0c2c67c18180000000086c66030180cc6c200000000, 256'h0000000076ccccccdc76386c6c38000000000000000000000000006030303000, 
256'h000000000c18303030303030180c00000000000030180c0c0c0c0c0c18300000, 256'h000000000000663cff3c66000000000000000000000018187e18180000000000, 
256'h0000003018181800000000000000000000000000000000007e00000000000000, 256'h000000001818000000000000000000000000000080c06030180c060200000000, 
256'h000000007cc6c6e6f6decec6c67c0000000000007e1818181818187838180000, 256'h00000000fec6c06030180c06c67c0000000000007cc60606063c0606c67c0000, 
256'h000000001e0c0c0cfecc6c3c1c0c0000000000007cc6060606fcc0c0c0fe0000, 256'h000000007cc6c6c6c6fcc0c0603800000000000030303030180c0606c6fe0000, 
256'h000000007cc6c6c6c67cc6c6c67c000000000000780c0606067ec6c6c67c0000, 256'h0000000000181800000018180000000000000000301818000000181800000000, 
256'h00000000060c18306030180c06000000000000000000007e00007e0000000000, 256'h000000006030180c060c183060000000000000001818001818180cc6c67c0000, 

256'h000000007cc0dcdededec6c6c67c000000000000c6c6c6c6fec6c66c38100000, 256'h00000000fc666666667c666666fc0000000000003c66c2c0c0c0c0c2663c0000, 
256'h00000000f86c6666666666666cf8000000000000fe6662606878686266fe0000, 256'h00000000f06060606878686266fe0000000000003a66c6c6dec0c0c2663c0000, 
256'h00000000c6c6c6c6c6fec6c6c6c60000000000003c18181818181818183c0000, 256'h0000000078cccccc0c0c0c0c0c1e000000000000e666666c78786c6666e60000, 
256'h00000000fe6662606060606060f0000000000000c3c3c3c3c3dbffffe7c30000, 256'h00000000c6c6c6c6cedefef6e6c60000000000007cc6c6c6c6c6c6c6c67c0000, 
256'h00000000f0606060607c666666fc000000000e0c7cded6c6c6c6c6c6c67c0000, 256'h00000000e66666666c7c666666fc0000000000007cc6c6060c3860c6c67c0000, 
256'h000000003c18181818181899dbff0000000000007cc6c6c6c6c6c6c6c6c60000, 256'h00000000183c66c3c3c3c3c3c3c30000000000006666ffdbdbc3c3c3c3c30000, 
256'h00000000c3c3663c18183c66c3c30000000000003c181818183c66c3c3c30000, 256'h00000000ffc3c16030180c86c3ff0000000000003c30303030303030303c0000, 
256'h0000000002060e1c3870e0c080000000000000003c0c0c0c0c0c0c0c0c3c0000, 256'h000000000000000000000000c66c38100000ff00000000000000000000000000, 	
	 
256'h000000000000000000000000001830300000000076cccccc7c0c780000000000, 256'h000000007c666666666c786060e00000000000007cc6c0c0c0c67c0000000000, 
256'h0000000076cccccccc6c3c0c0c1c0000000000007cc6c0c0fec67c0000000000, 256'h00000000f060606060f060646c3800000078cc0c7ccccccccccc760000000000, 
256'h00000000e666666666766c6060e00000000000003c1818181818380018180000, 256'h003c66660606060606060e000606000000000000e6666c78786c666060e00000, 
256'h000000003c181818181818181838000000000000dbdbdbdbdbffe60000000000, 256'h00000000666666666666dc0000000000000000007cc6c6c6c6c67c0000000000, 
256'h00f060607c6666666666dc0000000000001e0c0c7ccccccccccc760000000000, 256'h00000000f06060606676dc0000000000000000007cc60c3860c67c0000000000, 
256'h000000001c3630303030fc30301000000000000076cccccccccccc0000000000, 256'h00000000183c66c3c3c3c300000000000000000066ffdbdbc3c3c30000000000, 
256'h00000000c3663c183c66c3000000000000f80c067ec6c6c6c6c6c60000000000, 256'h00000000fec6603018ccfe0000000000000000000e18181818701818180e0000, 
256'h000000001818181818001818181800000000000070181818180e181818700000, 256'h000000000000000000000000dc7600000000000000fec6c6c66c381000000000};

assign pixel = charrom[{ascii[7:0], row, ~col}];

endmodule 
