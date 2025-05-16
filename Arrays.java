import java.util.*;

public class Arrays {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int size = scanner.nextInt();
        // scanner.nextLine();  // <-- Consume the leftover newline

        String[] names = new String[size];
        for (int i = 0; i < size; i++) {
            names[i] = scanner.nextLine();
        }

        for (int i = 0; i < size; i++) {
            System.out.print(names[i] + " ");
        }

        scanner.close();
    }
}