import java.util.Scanner; 
import java.util.ArrayList;
import java.util.*;
import java.io.*;
public class i281assembler {
	private class branchDest{
		public int line;
		public String branchName;
		public branchDest(int line,String branchName){
			this.line = line;
			this.branchName = branchName;
		}
	}
	private static final Object opcode = null;
	public static String[] instructionSet =  {"NOOP","INPUTC","INPUTCF","INPUTD","INPUTDF",
		"MOVE","LOADI","LOADP","ADD","ADDI","SUB","SUBI",
		"LOAD","LOADF","STORE","STOREF",
		"SHIFTL","SHIFTR","CMP","JUMP","BRE","BRNE","BRG","BRGE"}; //BRZ is an alias of BRE, BRNZ is an alias of BRNE
	/*
	   "0000_XX_XX_XXXXXXXX",
	   "0001_RR_SS_MADDRESS",
	   "0010_R1_SS_XXXXXXXX",
	   "0011_R1_XX_IMMEDVAL",

	   "0100_R1_R2_XXXXXXXX",
	   "0101_R1_XX_IMMEDVAL",
	   "0110_R1_R2_XXXXXXXX",
	   "0111_R1_XX_IMMEDVAL",

	   "1000_R1_XX_MADDRESS",
	   "1001_R1_R2_MEMOFSET",
	   "1010_R1_XX_MADDRESS",
	   "1011_R1_R2_MEMOFSET",

	   "1100_R1_XS_OOOFFSET",
	   "1101_R1_R2_XXXXXXXX",
	   "1110_XX_XX_OOOFFSET",
	   "1111_XX_CC_OOOFFSET"*/
	public static String[] instructionFormat =
	{
		"0000_", // NOOP
		"0001_", // INPUTC
		"0001_", // INPUTCF
		"0001_", // INPUTD
		"0001_", // INPUTDF
		"0010_", // MOVE
		"0011_", // LOADI
		"0011_", // LOADP

		"0100_", // ADD
		"0101_", // ADDI
		"0110_", // SUB
		"0111_", // SUBI

		"1000_", // LOAD
		"1001_", // LOADF
		"1010_", // STORE
		"1011_", // STOREF

		"1100_", // SHIFTL
		"1100_", // SHIFTR
		"1101_", // CMP
		"1110_", // JUMP
		"1111_", // BRE_BRZ
		"1111_", // BRNE_BRNZ
		"1111_", // BRG
		"1111_"  // BRGE
	};
	public static int dataLocation = 0;
	public static String registers = "ABCD";
	public static boolean debug = false;
	public static String machineCode = "";
	public static int dataIndex = 0;
	public static int lineNumber = 0;
	public static int codeSegmentStart;
	public static HashMap<String,Integer> valueMapping = new HashMap<String,Integer>();
	public static HashMap<String,Integer> branchDest = new HashMap<String,Integer>();
	public static ArrayList<Integer> dataValues = new ArrayList<Integer>();
	public static ArrayList<String> variableNames = new ArrayList<String>();
	public static ArrayList<String> arrayNames = new ArrayList<String>();
	public static void parseCodeSegment(Scanner asmScanner) {
		codeSegmentStart = lineNumber;
		while(asmScanner.hasNextLine()) {
			lineNumber++;
			String nextLine = asmScanner.nextLine();
			Scanner lineScanner = new Scanner(nextLine);
			if(lineScanner.hasNext()) {
				String opcode = lineScanner.next();
				if(opcode.equals("NOOP")) {
					getOpcodeBits("NOOP");
					parseNOOP();
				}
				else if(opcode.equals("LOADI")) {
					getOpcodeBits("LOADI");
					parseLOADI(lineScanner);
				}
				else if(opcode.equals("LOADP")) {
					getOpcodeBits("LOADP");
					parseLOADP(lineScanner);
				}
				else if(opcode.equals("CMP")) {
					getOpcodeBits("CMP");
					parseCMP(lineScanner);
				}
				else if(opcode.equals("LOAD")) {
					getOpcodeBits("LOAD");
					parseLOAD(lineScanner);
				}
				else if(opcode.equals("STORE")) {
					getOpcodeBits("STORE");
					parseSTORE(lineScanner);
				}
				else if(opcode.equals("STOREF")) {
					getOpcodeBits("STOREF");
					parseSTOREF(lineScanner);
				}
				else if(opcode.equals("LOADF")) {
					getOpcodeBits("LOADF");
					parseLOADF(lineScanner);
				}
				else if(opcode.equals("INPUT")) {
					getOpcodeBits("INPUT");
					parseINPUT(lineScanner);
				}
				else if(opcode.equals("BRE") || opcode.equals("BRZ")) {
					getOpcodeBits("BRE");
					parseBRE(lineScanner,lineNumber-codeSegmentStart);
				}
				else if(opcode.equals("BRNE") || opcode.equals("BRNZ")) {
					getOpcodeBits("BRNE");
					parseBRNE(lineScanner,lineNumber-codeSegmentStart);
				}
				else if(opcode.equals("BRG")) {
					getOpcodeBits("BRG");
					parseBRG(lineScanner,lineNumber-codeSegmentStart);
				}
				else if(opcode.equals("BRGE")) {
					getOpcodeBits("BRGE");
					parseBRGE(lineScanner,lineNumber-codeSegmentStart);
				}
				else if(opcode.equals("JUMP")) {
					getOpcodeBits("JUMP");
					parseJUMP(lineScanner,lineNumber-codeSegmentStart);
				}
				else if(opcode.equals("ADD")) {
					getOpcodeBits("ADD");
					parseADD(lineScanner);
				}
				else if(opcode.equals("ADDI")) {
					getOpcodeBits("ADDI");
					parseADDI(lineScanner);
				}
				else if(opcode.equals("SUB")) {
					getOpcodeBits("SUB");
					parseSUB(lineScanner);
				}
				else if(opcode.equals("SUBI")) {
					getOpcodeBits("SUBI");
					parseSUBI(lineScanner);
				}
				else if(opcode.equals("MOVE")) {
					getOpcodeBits("MOVE");
					parseMOVE(lineScanner);
				}
				else if(opcode.equals("INPUTC")) {
					getOpcodeBits("INPUTC");
					parseINPUTC(lineScanner);
				}
				else if(opcode.equals("INPUTCF")) {
					getOpcodeBits("INPUTCF");
					parseINPUTCF(lineScanner);
				}
				else if(opcode.equals("INPUTD")) {
					getOpcodeBits("INPUTD");
					parseINPUTD(lineScanner);
				}
				else if(opcode.equals("INPUTDF")) {
					getOpcodeBits("INPUTDF");
					parseINPUTDF(lineScanner);
				}
				else if(opcode.equals("SHIFTL")) {
					getOpcodeBits("SHIFTL");
					parseSHIFTL(lineScanner);
				}
				else if(opcode.equals("SHIFTR")) {
					getOpcodeBits("SHIFTR");
					parseSHIFTR(lineScanner);
				}
				else {
					errorMessage("Invalid opcode: " + opcode +" ");
				}
			}
			if(lineScanner.hasNext()){
				errorMessage("Extra tokens :" + "\"" + lineScanner.next() + "\"");
			}
		}
	}

	public static boolean isNumber(String toCheck){
		try{
			Integer.parseInt(toCheck);
		}catch(NumberFormatException e){
			return false;
		}
		return true;
	}

	public static void assignDataVariable(String toParse){
		Scanner innerScanner = new Scanner(toParse);
		String variableName = innerScanner.next();
		valueMapping.put(variableName,dataLocation);
		String BYTE = innerScanner.next();
		if(!BYTE.equals("BYTE")) {
			errorMessage("Expecting data type \" BYTE \" ");		
		}
		while(innerScanner.hasNext()){
			String innerString = innerScanner.next();
			if(innerString.equals(",")) {
				arrayNames.add(variableName);
				continue;
			}
			else if(innerString.equals("?")) {
				dataLocation++;
				dataValues.add(0);
				variableNames.add(variableName);
			}
			else{
				if(isNumber(innerString)) {
					dataLocation++;
					dataValues.add(Integer.parseInt(innerString));
					variableNames.add(variableName);
				}
				else
					errorMessage("Expecting numerical value, instead received" + innerString);
			}
		}
		if(variableNames.size()>16) {
			System.out.println("YOU HAVE MORE THAN 16 BYTES IN YOUR DATA SEGMENT!");
			System.out.println("No output generated.");
			System.exit(1);
		}
	}

	public static void findDataStart(Scanner asmScanner){
		while(asmScanner.hasNextLine()){
			lineNumber++;
			String lineRead = asmScanner.nextLine();
			if(lineRead.replace(" ","").equals("")) //Is empty line?
				continue;
			else if(lineRead.equals(".data")){
				parseDataSegment(asmScanner);
				break;
			}
			else{
				errorMessage("expecting \" .data \"");
			}
		}
	}

	public static void parseDataSegment(Scanner asmScanner) {
		while(asmScanner.hasNextLine()) {
			lineNumber++;
			String asmLine = asmScanner.nextLine();
			System.out.println(asmLine);
			if(asmLine.equals(".code"))
				return;
			String temp = asmLine.replaceAll(" ","");
			if(temp.length() == 0)
				continue;
			assignDataVariable(asmLine);

		}
	}
	public static void errorMessage(String error) {
		System.out.println(error +" on line: " + lineNumber);
		System.out.println(machineCode);
		System.exit(1);
	}
	public static String getRegisterName(String input) {
		if(input.equals("A")) {
			return "00_";
		}
		else if(input.equals("B")) {
			return "01_";
		}
		else if(input.equals("C")) {
			return "10_";
		}
		else if(input.equals("D")) {
			return "11_";
		}
		else {
			System.out.println(input);
			errorMessage("Expecting register name");
			return "0";
		}
	}
	public static String mapIntoBinary(String S1){
		String toReturn = S1;
		while(toReturn.length() < 8){
			toReturn = 0 + toReturn;
		}
		return toReturn;
	}

	public static String convertStringToBinary(String input) {
		try {
			int immedVal = Integer.parseInt(input);
			String eightBit = mapIntoBinary(Integer.toBinaryString(immedVal));//needs to handle negative number in the future.
			return eightBit;
		}catch(Exception e) {
			errorMessage("Expecting immediate value (integer)");
			return null;
		}
	}
	public static String convertIntToBinary(int input) {
		try {
			int immedVal = input;
			String eightBit = mapIntoBinary(Integer.toBinaryString(immedVal));//needs to handle negative number in the future.
			if(eightBit.length() > 8){// In case it is negative, truncat 111111111111101 to 11111101
				return eightBit.substring(eightBit.length()-8,eightBit.length());
			}
			return eightBit;
		}catch(Exception e) {
			errorMessage("Expecting immediate value (integer)");
			return null;
		}

	}
	public static void getComma(String input) {
		if(!input.equals(",")) {
			errorMessage("Expecting comma");
		}
	}

	public static void getLeftBracket(String input) {
		if(!input.equals("[")) {
			errorMessage("Expecting left bracket");
		}
	}

	public static void getRightBracket(String input) {
		if(!input.equals("]")) {
			errorMessage("Expecting right bracket");
		}
	}

	public static void getRightCurlyBracket(String input) {
		if(!input.equals("}")) {
			errorMessage("Expecting right curly bracket");
		}
	}

	public static void getLeftCurlyBracket(String input) {
		if(!input.equals("{")) {
			errorMessage("Expecting left curly bracket");
		}
	}
	public static void getPlus(String input) {
		if(!input.equals("+")) {
			errorMessage("Expecting +");
		}
	}

	public static void getMinus(String input) {
		if(!input.equals("-")) {
			errorMessage("Expecting -");
		}
	}

	public static void getOpcodeBits(String input) {
		for(int i = 0;i<instructionSet.length;i++) {
			if(input.equals(instructionSet[i])) {
				machineCode += instructionFormat[i];
				return;
			}
		}
		errorMessage("Expecting Opcode");
	}

	public static void parseNOOP(){
		machineCode += "00_00_00000000";
		machineCode += "\n";
	}

	public static void parseLOADI(Scanner asmScanner) {
		machineCode += getRegisterName(asmScanner.next());
		getComma(asmScanner.next());
		machineCode += "00_";
		machineCode += convertStringToBinary(asmScanner.next());
		machineCode += "\n";
	}
	//This is mapped to LOADI in opcode
	//This does not need the square brackets
	public static void parseLOADP(Scanner asmScanner) {
		machineCode += getRegisterName(asmScanner.next());
		getComma(asmScanner.next());
		machineCode += "00_";
		getLeftCurlyBracket(asmScanner.next());
		int dataLocation = valueMapping.get(asmScanner.next());
		String next = asmScanner.next();
		if(next.equals("+")) {
			dataLocation += Integer.parseInt(asmScanner.next());
			getRightCurlyBracket(asmScanner.next());
		}
		else{
			getRightCurlyBracket(next);
		}
		machineCode += convertIntToBinary(dataLocation);
		machineCode += "\n";
	}

	public static void parseCMP(Scanner asmScanner) {
		machineCode += getRegisterName(asmScanner.next());
		getComma(asmScanner.next());
		machineCode += getRegisterName(asmScanner.next());
		machineCode += "00000000";
		machineCode += "\n";
	}

	public static String parseDataAddress(Scanner asmScanner) {
		return convertIntToBinary(valueMapping.get(asmScanner.next()));
	}

	public static void parseINPUT(Scanner asmScanner) {
		machineCode +=  getRegisterName(asmScanner.next());
		getComma(asmScanner.next());
		machineCode += "00_";
		getLeftBracket(asmScanner.next());
		machineCode += parseDataAddress(asmScanner);
		getRightBracket(asmScanner.next());
		machineCode += "\n";
	}

	public static String branchDifference(int Line,String Destination){
		int diff = branchDest.get(Destination) - Line;
		return convertIntToBinary(diff);
	}

	public static void parseMOVE(Scanner asmScanner){
		machineCode += getRegisterName(asmScanner.next());
		getComma(asmScanner.next());
		machineCode += getRegisterName(asmScanner.next());
		machineCode += "00000000";
		machineCode += "\n";
	}

	public static void parseADD(Scanner asmScanner){
		machineCode += getRegisterName(asmScanner.next());
		getComma(asmScanner.next());
		machineCode += getRegisterName(asmScanner.next());
		machineCode += "00000000";
		machineCode += "\n";
	}

	public static void checkImmediateValueOutOfBounds(String immediateValue){
		if(immediateValue.contains("-"))
			errorMessage("Expecting positive immediate value. Negative number given");
		int immedVal = Integer.parseInt(immediateValue);
		if(immedVal < -128 || immedVal > 127)
			errorMessage("Immediate value " + immediateValue + " out of bounds");
	}

	public static void parseSHIFTR(Scanner asmScanner){
		machineCode += getRegisterName(asmScanner.next());
		machineCode += "01_00000000";
		machineCode += "\n";
	}

	public static void parseSHIFTL(Scanner asmScanner){
		machineCode += getRegisterName(asmScanner.next());
		machineCode += "00_00000000";
		machineCode += "\n";
	}

	public static void parseADDI(Scanner asmScanner){
		machineCode += getRegisterName(asmScanner.next());
		getComma(asmScanner.next());
		machineCode += "00_";
		String immediateValue = asmScanner.next();
		checkImmediateValueOutOfBounds(immediateValue);
		machineCode += convertStringToBinary(immediateValue);
		machineCode += "\n";
	}

	public static void parseSUB(Scanner asmScanner){
		machineCode += getRegisterName(asmScanner.next());
		getComma(asmScanner.next());
		machineCode += getRegisterName(asmScanner.next());
		machineCode += "00000000";
		machineCode += "\n";
	}

	public static void parseSUBI(Scanner asmScanner){
		machineCode += getRegisterName(asmScanner.next());
		getComma(asmScanner.next());
		machineCode += "00_";
		String immediateValue = asmScanner.next();
		checkImmediateValueOutOfBounds(immediateValue);
		machineCode += convertStringToBinary(immediateValue);
		machineCode += "\n";
	}

	public static void parseBRE(Scanner asmScanner, int Line) {
		machineCode += "00_00_";
		machineCode += branchDifference(Line,asmScanner.next());
		machineCode += "\n";
	}

	public static void parseBRNE(Scanner asmScanner, int Line) {
		machineCode += "00_01_";
		machineCode += branchDifference(Line,asmScanner.next());
		machineCode += "\n";
	}
	public static void parseJUMP(Scanner asmScanner, int Line) {
		machineCode += "00_00_";
		machineCode += branchDifference(Line,asmScanner.next());
		machineCode += "\n";
	}
	public static void parseBRG(Scanner asmScanner, int Line) {
		machineCode += "00_10_";
		machineCode += branchDifference(Line,asmScanner.next());
		machineCode += "\n";
	}

	public static void parseBRGE(Scanner asmScanner, int Line) {
		machineCode += "00_11_";
		machineCode += branchDifference(Line,asmScanner.next());
		machineCode += "\n";
	}

	public static void parseLOAD(Scanner asmScanner) {
		machineCode +=  getRegisterName(asmScanner.next());
		machineCode += "00_";
		getComma(asmScanner.next());
		getLeftBracket(asmScanner.next());
		String dataKey = asmScanner.next();
		String next = asmScanner.next();
		if(next.equals("+")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) + offset;
			checkAddressOutOfBounds(newOffset);
			machineCode+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("-")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) - offset;
			checkAddressOutOfBounds(newOffset);
			machineCode+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("]")){
			machineCode += convertIntToBinary(valueMapping.get(dataKey));
		}
		else {
			errorMessage("Expecting +,- or ]");
		}
		machineCode += "\n";
	}

	public static void parseINPUTCF(Scanner asmScanner) {
		String temp = "";
		getLeftBracket(asmScanner.next());
		String dataKey = asmScanner.next();
		getPlus(asmScanner.next());
		temp += getRegisterName(asmScanner.next());
		temp += "01_";
		String next = asmScanner.next();
		if(next.equals("+")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) + offset;
			checkAddressOutOfBounds(newOffset);
			temp+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("-")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) - offset;
			checkAddressOutOfBounds(newOffset);
			temp+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("]")){
			temp += convertIntToBinary(valueMapping.get(dataKey));
		}
		else {
			errorMessage("Expecting +,- or ]");
		}
		machineCode += temp;
		machineCode += "\n";
	}

	public static void parseINPUTC(Scanner asmScanner) {
		String temp = "";
		getLeftBracket(asmScanner.next());
		String dataKey = asmScanner.next();
		String next = asmScanner.next();
		if(next.equals("+")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) + offset;
			checkAddressOutOfBounds(newOffset);
			temp+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("-")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) - offset;
			checkAddressOutOfBounds(newOffset);
			temp+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("]")){
			temp += convertIntToBinary(valueMapping.get(dataKey));
		}
		else {
			errorMessage("Expecting +,- or ]");
		}
		machineCode += "00_00_";
		machineCode += temp;
		machineCode += "\n";
	}
	public static void parseINPUTD(Scanner asmScanner) {
		String temp = "";
		getLeftBracket(asmScanner.next());
		String dataKey = asmScanner.next();
		String next = asmScanner.next();
		if(next.equals("+")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) + offset;
			checkAddressOutOfBounds(newOffset);
			temp+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("-")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) - offset;
			checkAddressOutOfBounds(newOffset);
			temp+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("]")){
			temp += convertIntToBinary(valueMapping.get(dataKey));
		}
		else {
			errorMessage("Expecting +,- or ]");
		}
		machineCode += "00_10_";
		machineCode += temp;
		machineCode += "\n";
	}
	public static void parseINPUTDF(Scanner asmScanner) {
		String temp = "";
		getLeftBracket(asmScanner.next());
		String dataKey = asmScanner.next();
		getPlus(asmScanner.next());
		temp += getRegisterName(asmScanner.next());
		temp += "11_";
		String next = asmScanner.next();
		if(next.equals("+")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) + offset;
			checkAddressOutOfBounds(newOffset);
			temp+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("-")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) - offset;
			checkAddressOutOfBounds(newOffset);
			temp+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("]")){
			temp += convertIntToBinary(valueMapping.get(dataKey));
		}
		else {
			errorMessage("Expecting +,- or ]");
		}
		machineCode += temp;
		machineCode += "\n";
	}
	public static void parseSTOREF(Scanner asmScanner) {
		String temp = "";
		getLeftBracket(asmScanner.next());
		String dataKey = asmScanner.next();
		getPlus(asmScanner.next());
		temp += getRegisterName(asmScanner.next());
		String next = asmScanner.next();
		if(next.equals("+")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) + offset;
			warnAddressOutOfBounds(newOffset);
			temp+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("-")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) - offset;
			warnAddressOutOfBounds(newOffset);
			temp+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("]")){
			temp += convertIntToBinary(valueMapping.get(dataKey));
		}
		else {
			errorMessage("Expecting +,- or ]");
		}
		getComma(asmScanner.next());
		machineCode += getRegisterName(asmScanner.next());
		machineCode += temp;
		machineCode += "\n";
	}

	public static void parseSTORE(Scanner asmScanner) {
		getLeftBracket(asmScanner.next());
		String dataKey = asmScanner.next();
		String next = asmScanner.next();
		String temp = "";
		if(next.equals("+")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) + offset;
			checkAddressOutOfBounds(newOffset);
			temp+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("-")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) - offset;
			checkAddressOutOfBounds(newOffset);
			temp+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("]")){
			temp += convertIntToBinary(valueMapping.get(dataKey));
		}
		else {
			errorMessage("Expecting +,- or ]");
		}
		getComma(asmScanner.next());
		machineCode += getRegisterName(asmScanner.next());
		machineCode += "00_";
		machineCode += temp;
		machineCode += "\n";
	}

	public static boolean checkRightBracket(String input) {
		if(input.equals("]"))
			return true;
		return false;
	}

	public static void checkAddressOutOfBounds(int address){
		if(address < 0 || address > 63){
			errorMessage("Address out of bounds, attempting to access address " + address);
		}
	}
	public static void warnAddressOutOfBounds(int address) {
		if(address < 0 || address > 63){
			System.out.println("Warning: Address may be out of bounds depending on the value of the register.\n"
					+ "         Assuming it is 0, then attempting to access address " + address +".");
		}
	}
	public static void parseLOADF(Scanner asmScanner) {
		machineCode +=  getRegisterName(asmScanner.next());
		getComma(asmScanner.next());
		getLeftBracket(asmScanner.next());
		String dataKey = asmScanner.next();
		getPlus(asmScanner.next());
		machineCode += getRegisterName(asmScanner.next());
		String next = asmScanner.next();
		if(next.equals("+")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) + offset;
			warnAddressOutOfBounds(newOffset);
			machineCode+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("-")) {
			int offset = Integer.parseInt(asmScanner.next());
			int newOffset = valueMapping.get(dataKey) - offset;
			warnAddressOutOfBounds(newOffset);
			machineCode+= convertIntToBinary(newOffset);
			getRightBracket(asmScanner.next());
		}
		else if(next.equals("]")){
			machineCode += convertIntToBinary(valueMapping.get(dataKey));
		}
		else {
			errorMessage("Expecting +,- or ]");
		}
		machineCode += "\n";
	}
	public static String openFile(String fileName)throws FileNotFoundException {
		String fileReturn = "";
		File f = new File(fileName);
		Scanner fileOpener = new Scanner(f);
		while(fileOpener.hasNextLine()) {
			fileReturn += fileOpener.nextLine();
			fileReturn += "\n";
		}
		fileOpener.close();
		return fileReturn;
	}

	public static String removeComments(String asmFile) {
		Scanner asmScanner = new Scanner(asmFile);
		String toReturn = "";
		while(asmScanner.hasNextLine()) {
			String asmLine = asmScanner.nextLine();
			asmLine = asmLine.replace("," , " , ");
			asmLine = asmLine.replace("]" , " ] ");
			asmLine = asmLine.replace("[" , " [ ");
			asmLine = asmLine.replace("}" , " } ");
			asmLine = asmLine.replace("{" , " { ");
			asmLine = asmLine.replace("+" , " + ");
			asmLine = asmLine.replace("-" , " - ");
			if(asmLine.startsWith(";")) {
				toReturn += "\n";
				continue;
			}	
			else if(asmLine.contains(";")) {
				toReturn += asmLine.substring(0,asmLine.indexOf(";"));
				toReturn += "\n";
			}
			else {
				toReturn += asmLine;
				toReturn += "\n";
			}
		}
		asmScanner.close();
		return toReturn;
	}

	public static void parseLine(String asmFile) {
		Scanner asmScanner = new Scanner(asmFile);
		asmFile = removeComments(asmFile);
		while(asmScanner.hasNext()) {
			parseDataSegment(asmScanner);
		}
	}
/*
 * All lines after .code should start with a jump label (EX:) or opcode.
 * This method creates jump labels while simultaneously checking for incorrect tokens.
 * 
 */
	public static String getJumps(String codeSegment){
		String toReturn = "";
		Scanner eachLine = new Scanner(codeSegment);
		int lineCount = 0;
		boolean codeRead = false;
		while(eachLine.hasNextLine()){
			String line = eachLine.nextLine();
			if(line.contains(".code")) {
				lineCount = -1;
				codeRead = true;
				toReturn += ".code";
			}
			else if(line.contains(":")){
				branchDest.put(line.substring(0,line.indexOf(":")),lineCount);
				toReturn += line.substring(line.indexOf(":")+1,line.length());
			}
			else{
				if(codeRead) {
					Scanner findOpCode = new Scanner(line);
					boolean validOpCode = false;
					boolean validString = false;
					String firstToken ="";
					if(findOpCode.hasNext()) {
						firstToken = findOpCode.next();
						validString = true;
						for(int i = 0;i<instructionSet.length;i++) {
							if(firstToken.equals(instructionSet[i])) {
								validOpCode = true;
								break;
							}
						}
					}
					if(!validOpCode && validString) {
						System.out.println("Did you forget a colon(:) after your label? Incorrect token \"" + firstToken + "\" \n  at line \"" + line +"\"");
						System.exit(1);
					}
					findOpCode.close();
				}
				toReturn += line;
			}
			toReturn += "\n";
			lineCount++;
		}
		return toReturn;
	}
	
	public static void outputData(String fileName)throws FileNotFoundException{
		File F = new File(fileName.substring(0,fileName.lastIndexOf("/"))+"/User_Data.v");
		PrintWriter dataWriter = new PrintWriter(F);
		dataWriter.println("module User_Data(b0I,b1I,b2I,b3I,b4I,b5I,b6I,b7I,b8I,b9I,b10I,b11I,b12I,b13I,b14I,b15I);");
		dataWriter.println("output [7:0] b0I;\r\n" + 
				"output [7:0] b1I;\r\n" + 
				"output [7:0] b2I;\r\n" + 
				"output [7:0] b3I;\r\n" + 
				"output [7:0] b4I;\r\n" + 
				"output [7:0] b5I;\r\n" + 
				"output [7:0] b6I;\r\n" + 
				"output [7:0] b7I;\r\n" + 
				"output [7:0] b8I;\r\n" + 
				"output [7:0] b9I;\r\n" + 
				"output [7:0] b10I;\r\n" + 
				"output [7:0] b11I;\r\n" + 
				"output [7:0] b12I;\r\n" + 
				"output [7:0] b13I;\r\n" + 
				"output [7:0] b14I;\r\n" + 
				"output [7:0] b15I;\n");
		dataWriter.println("//FileName: "+fileName);
		int i = 0;
		int indexCount=0; 
		String currentName = "";
		for (i = 0;i<dataValues.size(); i++) {
			dataWriter.print("assign b" + i +"I[7:0] = 8'b"+convertIntToBinary(dataValues.get(i))+";");
			if(arrayNames.contains(variableNames.get(i))) {
				if(!currentName.equals(variableNames.get(i)))
					indexCount = i;
				currentName = variableNames.get(i);
				dataWriter.println(" //" + variableNames.get(i)+"[" + (i - indexCount) + "]");		
			}
			else {
				indexCount = 0;
				currentName = "";
				dataWriter.println(" //" + variableNames.get(i));
			}
				
		}
		for (; i < 16; i++) {
			dataWriter.println("assign b" + i +"I[7:0] = 8'b00000000;");
		}
		dataWriter.println("endmodule");
		dataWriter.close();
	}
 	public static void convertToOutput(String fileName) throws FileNotFoundException{
 		System.out.println(fileName);
		File F = new File(fileName.substring(0,fileName.lastIndexOf("/"))+"/User_Code_Low.v");
		File FF = new File(fileName.substring(0,fileName.lastIndexOf("/"))+"/User_Code_High.v");
		Scanner readLine = new Scanner(machineCode);
		PrintWriter p1 = new PrintWriter(F);
		PrintWriter p2 = new PrintWriter(FF);
		p1.print("module User_Code_Low(b0I,b1I,b2I,b3I,b4I,b5I,b6I,b7I,b8I,b9I,b10I,b11I,b12I,b13I,b14I,b15I);\r\n" + 
				"\r\n" + 
				"output [16:0] b0I;\r\n" + 
				"output [16:0] b1I;\r\n" + 
				"output [16:0] b2I;\r\n" + 
				"output [16:0] b3I;\r\n" + 
				"output [16:0] b4I;\r\n" + 
				"output [16:0] b5I;\r\n" + 
				"output [16:0] b6I;\r\n" + 
				"output [16:0] b7I;\r\n" + 
				"output [16:0] b8I;\r\n" + 
				"output [16:0] b9I;\r\n" + 
				"output [16:0] b10I;\r\n" + 
				"output [16:0] b11I;\r\n" + 
				"output [16:0] b12I;\r\n" + 
				"output [16:0] b13I;\r\n" + 
				"output [16:0] b14I;\r\n" + 
				"output [16:0] b15I;\r\n\n");
		Scanner S = new Scanner(machineCode);
		int i = 0;
		for (i = 0;S.hasNextLine()&&i<16; i++) {
			String lineRead = S.nextLine();
			p1.println("assign b" + i +"I[16:0] = 17'b"+"0_"+lineRead+";");
		}
		for (; i < 16; i++) {
			p1.println("assign b" + i +"I[16:0] = 17'b0_0000_00_00_00000000;");
		}
		p1.println("endmodule");
		p2.print("module User_Code_High(b0I,b1I,b2I,b3I,b4I,b5I,b6I,b7I,b8I,b9I,b10I,b11I,b12I,b13I,b14I,b15I);\r\n" + 
				"\r\n" + 
				"output [16:0] b0I;\r\n" + 
				"output [16:0] b1I;\r\n" + 
				"output [16:0] b2I;\r\n" + 
				"output [16:0] b3I;\r\n" + 
				"output [16:0] b4I;\r\n" + 
				"output [16:0] b5I;\r\n" + 
				"output [16:0] b6I;\r\n" + 
				"output [16:0] b7I;\r\n" + 
				"output [16:0] b8I;\r\n" + 
				"output [16:0] b9I;\r\n" + 
				"output [16:0] b10I;\r\n" + 
				"output [16:0] b11I;\r\n" + 
				"output [16:0] b12I;\r\n" + 
				"output [16:0] b13I;\r\n" + 
				"output [16:0] b14I;\r\n" + 
				"output [16:0] b15I;\r\n\n");
		for (i = 0;S.hasNextLine()&&i<16; i++) {
			String lineRead = S.nextLine();
			p2.println("assign b" + i +"I[16:0] = 17'b"+"0_"+lineRead+";");
		}
		for (; i < 16; i++) {
			p2.println("assign b" + i +"I[16:0] = 17'b0_0000_00_00_00000000;");
		}
		p2.println("endmodule");
		p1.close();
		p2.close();
	}
 	
	public static void reInit(){
		int dataLocation = 0;
		boolean debug = false;
		String machineCode = "";
		int dataIndex = 0;
		int lineNumber = 0;
		HashMap<String,Integer> valueMapping = new HashMap<String,Integer>();
		HashMap<String,Integer> branchDest = new HashMap<String,Integer>();
	}
	
	public static void runOnAll(File inputF)throws FileNotFoundException{
		if(inputF.isDirectory()){
			File[] subDir = inputF.listFiles();
			for (int i = 0; i < subDir.length; i++) {
				runOnAll(subDir[i]);
			}
		}
		else{
			if(inputF.getName().contains(".asm")){
				System.out.println(inputF.getAbsolutePath());
				String opened = openFile(inputF.getAbsolutePath());
				System.out.println(opened);
				String noComments = removeComments(opened);
				System.out.println(noComments);
				if(debug)
					System.out.println(noComments + "\n -----------------------");
				noComments = getJumps(noComments);
				if(!debug)
					System.out.println(noComments + "\n -----------------------");
				Scanner asmScanner = new Scanner(noComments);
				findDataStart(asmScanner);
				parseCodeSegment(asmScanner);
				System.out.println(machineCode);
				convertToOutput(inputF.getAbsolutePath());
				//if(debug){
				System.out.println("---------DEBUG--------");
				System.out.println("Branch Destinations:");
				System.out.println(branchDest);
				System.out.println(valueMapping);
				asmScanner.close();
				reInit();
				}
			}
	}
	public static void main(String[]args) throws FileNotFoundException{
		if(args.length>=1){
			System.out.println(args[0]);
			String opened = openFile(args[0]);
			File binWriteFile = new File(args[0].substring(0,args[0].lastIndexOf("."))+".bin");
			PrintWriter binWrite = new PrintWriter(binWriteFile);
			Scanner withLines = new Scanner(opened);
			for(int i = 1;withLines.hasNextLine();i++) {
				if(i<10)
					System.out.println(" " + i + "|  " + withLines.nextLine());
				else
					System.out.println(i + "|  " + withLines.nextLine());
			}
			System.out.println();
			withLines.close();
			String noComments = removeComments(opened);
			binWrite.println(opened + "\n-----MACHINE CODE-----");
			noComments = getJumps(noComments);
			Scanner asmScanner = new Scanner(noComments);
			findDataStart(asmScanner);
			parseCodeSegment(asmScanner);
			System.out.println("-----MACHINE CODE-----");
			System.out.print(machineCode);
			System.out.println("----------------------");
			binWrite.println(machineCode);
			convertToOutput(args[0]);
			outputData(args[0]);
			binWrite.println("-----DATA SEGMENT-----");
			binWrite.println(dataValues);
			//if(debug){
			binWrite.println("---------DEBUG--------");
			binWrite.println("Branch Destinations:");
			binWrite.println(branchDest);
			binWrite.println(valueMapping);
			System.out.println("Branch Destinations:");
			System.out.println(branchDest + "\n");
			System.out.println("Variable Addresses:");
			System.out.println(valueMapping+"\n");
			reInit();
			//File F = new File(".");
			//runOnAll(F);
		binWrite.close();	
		System.out.println("Compilation Successful.");
		System.out.println("	Output written to : " + args[0].replace(".asm", ".bin"));
		System.out.println("	Output written to : " + args[0].substring(0,args[0].lastIndexOf("/"))+"/User_Code_Low.v");
		System.out.println("	Output written to : " + args[0].substring(0,args[0].lastIndexOf("/"))+"/User_Code_High.v");
		System.out.println("	Output written to : " + args[0].substring(0,args[0].lastIndexOf("/"))+"/User_Data.v");
		}
		}
	}
