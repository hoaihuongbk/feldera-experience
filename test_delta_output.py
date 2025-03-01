from lakeops import LakeOps

def validate_delta_output(path):
    # Initialize with default Polars engine
    ops = LakeOps()

    # Read Delta table
    raw_df = ops.read(path, format="delta")

    # Print the DataFrame
    print("Raw DataFrame:")
    print(raw_df)


    filter_df = raw_df.group_by("source_ip").tail(1)
    print("Filtered DataFrame:")
    print(filter_df)


if __name__ == "__main__":
    # Example path to Delta table
    delta_path = "app/data/potential_brute_force"
    validate_delta_output(delta_path)
