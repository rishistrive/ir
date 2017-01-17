class AddPasswordDigestToInspectors < ActiveRecord::Migration
  def up
    add_column "inspectors", "password_digest", :string
  end
  
  def down
    remove_column "inspectors", "password_digest"
  end
end
