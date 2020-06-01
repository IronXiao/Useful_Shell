import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.Arrays;

public class NtpTest {

    private static final int ORIGINATE_TIME_OFFSET = 24;

    private static final int RECEIVE_TIME_OFFSET = 32;

    private static final int NTP_PACKET_SIZE = 48;

    private static final int NTP_PORT = 123;

    private static final int TIMEOUT = 20000;

    private static final String SERVER = "time1.aliyun.com";

    private static final int TRANSMIT_TIME_OFFSET = 40;

    private static final int NTP_MODE_CLIENT = 3;

    private static final int NTP_VERSION = 3;

    private static final long OFFSET_1900_TO_1970 = ((365L * 70L) + 17L) * 24L * 60L * 60L;

    public static void main(String[] args) {
//        requestTime(SERVER, TIMEOUT);
        if (args.length != 1) {
            System.out.println("Must need a ntp server to do this job !!!");
            System.exit(0);
        }
        System.out.println("Start fetch time form " + args[0]);
        requestTime(args[0], TIMEOUT);

    }

    private static boolean requestTime(String host, int timeout) {
        DatagramSocket socket = null;
        try {
            socket = new DatagramSocket();
            socket.setSoTimeout(timeout);
            InetAddress address = InetAddress.getByName(host);
            byte[] buffer = new byte[NTP_PACKET_SIZE];
            DatagramPacket request = new DatagramPacket(buffer, buffer.length, address, NTP_PORT);
            buffer[0] = NTP_MODE_CLIENT | (NTP_VERSION << 3);
            long requestTime = System.currentTimeMillis();
            writeTimeStamp(buffer, TRANSMIT_TIME_OFFSET, requestTime);
            socket.send(request);
            DatagramPacket response = new DatagramPacket(buffer, buffer.length);
            socket.receive(response);
            System.out.println(buffer.toString());
            long originateTime = readTimeStamp(buffer, ORIGINATE_TIME_OFFSET);
            long receiveTime = readTimeStamp(buffer, RECEIVE_TIME_OFFSET);
            long transmitTime = readTimeStamp(buffer, TRANSMIT_TIME_OFFSET);
            System.out.println("originateTime: " + originateTime);
            System.out.println("receiveTime: " + receiveTime);
            System.out.println("transmitTime: " + transmitTime);
			String formats = "yyyy-MM-dd HH:mm:ss";
			String date = new SimpleDateFormat(formats, Locale.CHINA).format(new Date(receiveTime));
			System.out.println("Current time is: " + date);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            if (socket != null) {
                socket.close();
            }
        }

        return true;
    }

    private static void writeTimeStamp(byte[] buffer, int offset, long time) {
        if (time == 0) {
            Arrays.fill(buffer, offset, offset + 8, (byte) 0x00);
            return;
        }

        long seconds = time / 1000L;
        long milliseconds = time - seconds * 1000L;
        seconds += OFFSET_1900_TO_1970;
        buffer[offset++] = (byte) (seconds >> 24);
        buffer[offset++] = (byte) (seconds >> 16);
        buffer[offset++] = (byte) (seconds >> 8);
        buffer[offset++] = (byte) (seconds >> 0);

        long fraction = milliseconds * 0x100000000L / 1000L;
        buffer[offset++] = (byte) (fraction >> 24);
        buffer[offset++] = (byte) (fraction >> 16);
        buffer[offset++] = (byte) (fraction >> 8);
        buffer[offset++] = (byte) (Math.random() * 255.0);
    }

    private static long readTimeStamp(byte[] buffer, int offset) {
        long seconds = read32(buffer, offset);
        long fraction = read32(buffer, offset + 4);
        return ((seconds - OFFSET_1900_TO_1970) * 1000) + ((fraction * 1000L) / 0x100000000L);
    }

    private static long read32(byte[] buffer, int offset) {
        byte b0 = buffer[offset];
        byte b1 = buffer[offset + 1];
        byte b2 = buffer[offset + 2];
        byte b3 = buffer[offset + 3];
        int i0 = ((b0 & 0x80) == 0x80 ? (b0 & 0x7F) + 0x80 : b0);
        int i1 = ((b1 & 0x80) == 0x80 ? (b1 & 0x7F) + 0x80 : b1);
        int i2 = ((b2 & 0x80) == 0x80 ? (b2 & 0x7F) + 0x80 : b2);
        int i3 = ((b3 & 0x80) == 0x80 ? (b3 & 0x7F) + 0x80 : b3);

        return ((long) i0 << 24) + ((long) i1 << 16) + ((long) i2 << 8) + (long) i3;
    }
}
