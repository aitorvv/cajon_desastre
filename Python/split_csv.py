import pandas as pd
import os


def split_csv(csv_path, block_size):
    df = pd.read_csv(csv_path)
    total_rows = len(df)
    total_split_file = int(total_rows/block_size)
    orig_path = os.path.splitext(csv_path)[0]
    for i in range(total_split_file):
        if i == (total_split_file - 1):
            new_df = df[i*block_size: i*block_size + block_size]
            new_df_last = df[(i*block_size) + block_size: ]
            path_save = orig_path + '_' + str(i*block_size + 1) + '_' + str(i*block_size + block_size) + '.csv'
            path_save_last = orig_path + '_' + str(i*block_size + block_size + 1) + '_' + str(total_rows) + '.csv'
            new_df_last.to_csv(path_save_last)

        else:
            new_df = df[i*block_size: i*block_size + block_size]
            path_save = orig_path + '_' + str(i*block_size + 1) + '_' + str(i*block_size + block_size) + '.csv'
        new_df.to_csv(path_save)



if __name__ == '__main__':
    csv_path = input('Paste here the path of your csv file: ')  # set here the path
    block_size = int(input('How many rows do you want to obtain per file?: '))  # and here the maximum of rows per file
    split_csv(csv_path, block_size)
