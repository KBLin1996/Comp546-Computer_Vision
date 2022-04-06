function display_confusion_matrix(confusion_matrix)
    fprintf("--------------------------- Result ---------------------------\n");
    fprintf("|  Classes  |     Hat     |   Butterfly   |   Airplane   |\n");
    fprintf("----------------------------------------------------------------\n");
    fprintf("|     Hat     |   %.2f%%    |   %.2f%%   |   %.2f%%   |\n", confusion_matrix(1,1), confusion_matrix(1,2), confusion_matrix(1,3));  
    fprintf("----------------------------------------------------------------\n");
    fprintf("|  Butterfly  |   %.2f%%    |   %.2f%%   |   %.2f%%   |\n", confusion_matrix(2,1), confusion_matrix(2,2),confusion_matrix(2,3));  
    fprintf("----------------------------------------------------------------\n");
    fprintf("|  Airplane  |   %.2f%%    |   %.2f%%   |   %.2f%%   |\n", confusion_matrix(3,1), confusion_matrix(3,2),confusion_matrix(3,3));  
    fprintf("----------------------------------------------------------------\n");
end