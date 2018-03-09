package com.ms.k8s.HappyFriday;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Random;

public class HappyQuoteFactory {
	private static Random RND = new Random();
	private static String[] QUOTES = new String[] { "When Chuck Norris throws exceptions, it’s across the room.",
			"All arrays Chuck Norris declares are of infinite size, because Chuck Norris knows no bounds.",
			"Chuck Norris doesn’t have disk latency because the hard drive knows to hurry the hell up.",
			"Chuck Norris writes code that optimizes itself.",
			"Chuck Norris doesn’t need garbage collection because he doesn’t call .Dispose(), he calls .DropKick().",
			"Chuck Norris’s first program was kill -9.",
			"Chuck Norris can write infinite recursion functions…and have them return.",
			"Chuck Norris doesn’t use web standards as the web will conform to him.",
			"Chuck Norris can delete the Recycling Bin.",
			"Chuck Norris can unit test entire applications with a single assert.",
			"Chuck Norris’s keyboard doesn’t have a Ctrl key because nothing controls Chuck Norris.",
			"Chuck Norris doesn’t need a debugger, he just stares down the bug until the code confesses." ,
			"If Chuck Norris were a programmer, unstructured data would become structured. With Chuck around, nobody ever gets out of line."
	};

	public static final String getQuote() {
		int i = RND.nextInt(QUOTES.length);
		return i + " {" + QUOTES[i] + "} from " + getHostName() + "@" + getLocalIpAddress();
	}

	public static String getHostName() {
		String hostName = null;
		Runtime run = Runtime.getRuntime();
		Process proc;
		try {
			proc = run.exec("hostname");
			BufferedInputStream in = new BufferedInputStream(proc.getInputStream());
			byte[] b = new byte[256];
			in.read(b);
			hostName = new String(b);
			return hostName;
		} catch (IOException e1) {
			try {
				hostName = InetAddress.getLocalHost().getHostName();
				return hostName + " - AzureRocks !!! ";
			} catch (UnknownHostException e) {
				return "";
			}
		}
	}

	public static String getLocalIpAddress() {
		try {
			return InetAddress.getLocalHost().getHostAddress();
		} catch (UnknownHostException e) {
			return "";
		}
	}
}
