import pandas as pd

file = "test_output"
# Load the CSV file
df = pd.read_csv(f"{file}.csv", header=None)

# Remove the quotes in the second column
df[1] = df[1].str.replace('"', "")

# Create a dictionary to map each unique label to a numeric ID
label_to_id = {label: idx for idx, label in enumerate(df[1].unique())}
print(df[1].unique().shape)

# Replace the labels with their corresponding numeric IDs
df[1] = df[1].map(label_to_id)

# Save the updated CSV
df.to_csv(f"{file}.csv", header=False, index=False)
