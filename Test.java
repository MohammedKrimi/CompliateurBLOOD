import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.util.Scanner;

import org.antlr.runtime.ANTLRInputStream;
import org.antlr.runtime.CommonTokenStream;

public class Test {

	PrintStream newSystemErr, oldSystemErr;
	ByteArrayOutputStream outputStream;
	FileInputStream inputStream;
	File file;
	int validity = 0;

	public Test(String fileName) throws IOException {
		outputStream = new ByteArrayOutputStream();
		newSystemErr = new PrintStream(outputStream);
		oldSystemErr = System.err;
		file = new File(fileName);
		inputStream = new FileInputStream(file);
		setUpValidity();
	}

	public int getReverseValidity() {
		return Math.abs((validity - 1)) ;
	}

	public void setUpValidity() throws IOException {
		InputStream in = new FileInputStream(file);
		Scanner scan = new Scanner(in);
		String firstLine = scan.nextLine();
		scan.close();
		in.close();
		if (!firstLine.startsWith("//")) {
			throw new IOException("Les fichiers tests doivent commencer avec un commentaire : soit //true ou //false");
		}
		if (firstLine.equalsIgnoreCase("//false")) {
			validity = 1;
		}
	}

	public void setUpSystemErr() {
		System.err.flush();
		System.setErr(newSystemErr);
	}

	public void removeSystemErr() {
		System.err.flush();
		System.setErr(oldSystemErr);
	}

	public void runAntlr() throws Exception {
		ANTLRInputStream input = new ANTLRInputStream(inputStream);
		Gram3Lexer lexer = new Gram3Lexer(input);
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		Gram3Parser parser = new Gram3Parser(tokens);
		Object stop = parser.program().getStop();
		if(stop == null) {
			throw new Exception("La grammaire n'a pas pu être lu entierement");
		}
	}

	public boolean assertTrue() {
		return outputStream.toString().length() == 0;
	}

	public void closeTest() throws IOException {
		inputStream.close();
		outputStream.close();
		newSystemErr.close();
	}

	public int run() {
		try {
			setUpSystemErr();
			runAntlr();
			if (!assertTrue()) {
				throw new Exception(outputStream.toString());
			}
			removeSystemErr();
			closeTest();
		} catch (Exception e) {
			System.out.println(e.getMessage());
			return getReverseValidity();
		}
		return validity;
	}

	public static void main(String[] args) throws Exception {
		Test test = new Test(args[0]);
		int status = test.run();
		System.out.println("Status : " + status);
		System.exit(status);
	}

}
