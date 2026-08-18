import pandas as pd
for f in ["sales_10000.csv","hr_10000.csv","iot_10000.csv"]:
    df=pd.read_csv("../datasets/"+f,dtype=str)
    print("\n===",f,"===")
    print("Rows:",len(df)," Columns:",len(df.columns))
    print("Missing:\n",df.isna().sum())
    print("Duplicate rows:",df.duplicated().sum())
    for c in df.columns:
        print("\n",c,"unique:",df[c].nunique(dropna=True))
        print(df[c].value_counts(dropna=False).head(10))
