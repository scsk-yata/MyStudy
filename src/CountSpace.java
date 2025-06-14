class CountSpace {
    private int countSpace(String str){
        int count = 0;
        for (int i = 0; i < str.length(); i++)
            if (str.charAt(i) == ' ')
                count++;
        return count;
    }

    public static void main(String args[]){
        CountSpace cs = new CountSpace();
        System.out.println(cs.countSpace("This is a pen."));
    }
}
